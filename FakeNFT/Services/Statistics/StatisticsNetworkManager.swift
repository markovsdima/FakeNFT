import Foundation

enum StatisticsNetworkManagerError: Error {
    case unwrapRequestFailed
    case invalidRequest
    case emptyResponse
    case convertFailed
    case convertMockJsonToDataFailed
}

fileprivate enum DataSource {
    case mock
    case server
}

final class StatisticsNetworkManager {
    
    // MARK: - Switch between mock and server data sources
    private let dataSource: DataSource = .server
    
    // MARK: - Public Properties
    static let shared = StatisticsNetworkManager()
    private init() {}
    
    // MARK: - Private Properties
    private let host = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    private let token: String = "6fe3b0b3-4795-4199-a00d-e90e16f22517"
    
    private let session = URLSession.shared
    private let usersListPageSize = 15
    private let decoder = JSONDecoder()
    private var usersList: [StatisticsUser] = []
    private let mockServer = StatisticsMockData.shared
    private var myNftLikes: [String] = []
    private var cartNfts: [String] = []
    
    // MARK: - Public Methods
    // Additional
    func getMyNftLikes() async throws {
        myNftLikes = try await getLikesFromResponse()
    }
    
    func getCartNfts() async throws {
        cartNfts = try await getCartNftsFromResponse()
    }
    
    func checkNftLike(id: String) -> Bool {
        return myNftLikes.contains(id)
    }
    
    func checkCartContainsNft(id: String) -> Bool {
        return cartNfts.contains(id)
    }
    
    // Getting ready to use structures
    func getUsersListFromResponse(page: Int, sortType: StatisticsSortCases) async throws -> [StatisticsUser] {
        
        let response: (Data, URLResponse)
        
        switch dataSource {
        case .mock:
            response = try await mockServer.getUsersListData(pageNumber: page)
        case .server:
            response = try await fetchUsersList(pageNumber: page, sortType: sortType)
        }
        
        let decodedResponse = try? decoder.decode(
            [StatisticsUserListResponse].self,
            from: response.0
        )
        
        guard decodedResponse != [] && decodedResponse != nil else {
            throw StatisticsNetworkManagerError.emptyResponse
        }
        guard let usersList = convertUsersList(response: decodedResponse) else { return [] }
        
        return usersList
    }
    
    func getUserInfoFromResponse(id: String) async throws -> StatisticsUserAdvanced {
        
        let response: (Data, URLResponse)
        
        switch dataSource {
        case .mock:
            response = try await mockServer.getUserInfoData()
        case .server:
            response = try await fetchUserInfo(id: id)
        }
        
        let decodedResponse = try? decoder.decode(
            StatisticsUserResponse.self,
            from: response.0
        )
        
        guard (decodedResponse != nil) else {
            throw StatisticsNetworkManagerError.emptyResponse
        }
        
        guard let userInfo = convertUserInfo(response: decodedResponse) else {
            throw StatisticsNetworkManagerError.convertFailed
        }
        
        return userInfo
    }
    
    func getNftsFromResponses(nftsIds: [String]) async throws -> [StatisticsNFTCell] {
        var nfts: [StatisticsNFTCell] = []
        
        if dataSource == .mock {
            let response = try await mockServer.getNft()
            let decodedResponse = try? decoder.decode(
                StatisticsNFTResponse.self,
                from: response.0
            )
            guard (decodedResponse != nil) else {
                throw StatisticsNetworkManagerError.emptyResponse
            }
            guard let nft = convertNft(response: decodedResponse) else {
                throw StatisticsNetworkManagerError.convertFailed
            }
            nfts.append(nft)
            return nfts
        }
        
        for id in nftsIds {
            let response = try await fetchNft(id: id)
            let decodedResponse = try? decoder.decode(
                StatisticsNFTResponse.self,
                from: response.0
            )
            guard (decodedResponse != nil) else {
                throw StatisticsNetworkManagerError.emptyResponse
            }
            guard let nft = convertNft(response: decodedResponse) else {
                throw StatisticsNetworkManagerError.convertFailed
            }
            nfts.append(nft)
        }
        
        return nfts
    }
    
    func getLikesFromResponse() async throws -> [String] {
        let response = try await fetchLikes()
        let decodedResponse = try? decoder.decode(
            StatisticsLikesResponse.self,
            from: response.0
        )
        guard (decodedResponse != nil) else {
            throw StatisticsNetworkManagerError.emptyResponse
        }
        guard let likes = convertLikes(response: decodedResponse) else {
            throw StatisticsNetworkManagerError.convertFailed
        }
        
        return likes
    }
    
    func getCartNftsFromResponse() async throws -> [String] {
        let response = try await fetchCart()
        let decodedResponse = try? decoder.decode(
            StatisticsCartResponse.self,
            from: response.0
        )
        guard (decodedResponse != nil) else {
            throw StatisticsNetworkManagerError.emptyResponse
        }
        guard let nfts = convertCart(response: decodedResponse) else {
            throw StatisticsNetworkManagerError.convertFailed
        }
        
        return nfts
    }
    
    // Updating server data
    func updateNftLike(nftId: String) async throws {
        
        var newLikedNfts = [String]()
        var bodyString = String()
        
        if myNftLikes.contains(nftId) {
            newLikedNfts = myNftLikes.filter { $0 != nftId }
        } else {
            newLikedNfts = myNftLikes + [nftId]
        }
        
        let nftsString = newLikedNfts.joined(separator: ",")
        bodyString = "likes=\(nftsString)"
        
        if newLikedNfts == [] {
            bodyString = "likes=null"
        }
        
        guard let bodyData = bodyString.data(using: .utf8) else {
            throw StatisticsNetworkManagerError.convertFailed
        }
        
        try await sendProfileLikes(body: bodyData)
        myNftLikes = newLikedNfts
    }
    
    func updateCart(nftId: String) async throws {
        var newCartNfts = [String]()
        var bodyString = String()
        
        if cartNfts.contains(nftId) {
            newCartNfts = cartNfts.filter { $0 != nftId }
        } else {
            newCartNfts = cartNfts + [nftId]
        }
        
        let nftsString = newCartNfts.joined(separator: ",")
        bodyString = "nfts=\(nftsString)"
        
        if newCartNfts == [] {
            bodyString = "nfts=null"
        }
        
        guard let bodyData = bodyString.data(using: .utf8) else {
            throw StatisticsNetworkManagerError.convertFailed
        }
        
        try await sendCart(body: bodyData)
        cartNfts = newCartNfts
    }
    
    // MARK: - Private Methods
    // Converting data
    private func convertUsersList(response: [StatisticsUserListResponse]?) -> [StatisticsUser]? {
        var list: [StatisticsUser] = []
        guard let response else { return nil }
        for user in response {
            list.append(StatisticsUser(
                name: user.name,
                score: user.nfts.count,
                rating: user.rating,
                id: user.id,
                avatar: user.avatar
            ))
        }
        return list
    }
    
    private func convertUserInfo(response: StatisticsUserResponse?) -> StatisticsUserAdvanced? {
        guard let response else { return nil }
        
        let userInfo = StatisticsUserAdvanced(
            name: response.name,
            avatar: response.avatar,
            description: response.description,
            nftsCount: response.nfts.count,
            website: response.website,
            nfts: response.nfts
        )
        return userInfo
    }
    
    private func convertNft(response: StatisticsNFTResponse?) -> StatisticsNFTCell? {
        guard let response else { return nil }
        
        let nft = StatisticsNFTCell(
            name: response.name,
            price: response.price,
            rating: response.rating,
            isLiked: checkNftLike(id: response.id),
            id: response.id,
            images: response.images,
            isOrdered: checkCartContainsNft(id: response.id)
        )
        
        return nft
    }
    
    private func convertLikes(response: StatisticsLikesResponse?) -> [String]? {
        guard let response else { return [] }
        
        let likes = response.likes
        return likes
    }
    
    private func convertCart(response: StatisticsCartResponse?) -> [String]? {
        guard let response else { return [] }
        
        let nfts = response.nfts
        return nfts
    }
    
    // Fetching requests
    private func fetchUsersList(pageNumber: Int, sortType: StatisticsSortCases) async throws -> (Data, URLResponse) {
        guard let request = createUsersListRequest(pageNumber: pageNumber, sortType: sortType) else {
            throw StatisticsNetworkManagerError.unwrapRequestFailed
        }
        let response = try await session.data(for: request)
        
        return response
    }
    
    private func fetchUserInfo(id: String) async throws -> (Data, URLResponse) {
        guard let request = createUserInfoRequest(id: id) else {
            throw StatisticsNetworkManagerError.unwrapRequestFailed
        }
        let response = try await session.data(for: request)
        
        return response
    }
    
    private func fetchNft(id: String) async throws -> (Data, URLResponse) {
        guard let request = createNftRequest(id: id) else {
            throw StatisticsNetworkManagerError.unwrapRequestFailed
        }
        let response = try await session.data(for: request)
        
        return response
    }
    
    private func fetchLikes() async throws -> (Data, URLResponse) {
        guard let request = createGetLikesRequest() else {
            throw StatisticsNetworkManagerError.unwrapRequestFailed
        }
        let response = try await session.data(for: request)
        
        return response
    }
    
    private func sendProfileLikes(body: Data?) async throws {
        guard let request = createUpdateLikesRequest(body: body) else {
            throw StatisticsNetworkManagerError.unwrapRequestFailed
        }
        _ = try await session.data(for: request)
    }
    
    private func fetchCart() async throws -> (Data, URLResponse) {
        guard let request = createGetCartRequest() else {
            throw StatisticsNetworkManagerError.unwrapRequestFailed
        }
        let response = try await session.data(for: request)
        
        return response
    }
    
    private func sendCart(body: Data?) async throws {
        guard let request = createUpdateCartRequest(body: body) else {
            throw StatisticsNetworkManagerError.unwrapRequestFailed
        }
        _ = try await session.data(for: request)
    }
    
    // Creating requests
    private func createUsersListRequest(pageNumber: Int, sortType: StatisticsSortCases) -> URLRequest? {
        var urlComponents = URLComponents()
        
        var sortByValue = ""
        
        switch sortType {
        case .byName:
            sortByValue = "name,asc"
        case .byRating:
            sortByValue = "rating,desc"
        }
        
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/users"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "size", value: "\(usersListPageSize)"),
            URLQueryItem(name: "sortBy", value: sortByValue)
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func createUserInfoRequest(id: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/users/\(id)"
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func createNftRequest(id: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/nft/\(id)"
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func createGetLikesRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/profile/1"
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func createUpdateLikesRequest(body: Data?) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/profile/1"
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        return request
    }
    
    private func createGetCartRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/orders/1"
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func createUpdateCartRequest(body: Data?) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/orders/1"
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        return request
    }
}
