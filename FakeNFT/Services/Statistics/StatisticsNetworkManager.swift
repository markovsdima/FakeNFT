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
    private let dataSource: DataSource = .mock
    
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
    
    // MARK: - Public Methods
    // Getting ready to use structures
    func getUsersListFromResponse(page: Int) async throws -> [StatisticsUser] {
        
        let response: (Data, URLResponse)
        
        switch dataSource {
        case .mock:
            response = try await mockServer.getUsersListData(pageNumber: page)
        case .server:
            response = try await fetchUsersList(pageNumber: page)
        }
        
        let decodedResponse = try? decoder.decode(
            [StatisticsUserListResponse].self,
            from: response.0
        )
        
        guard decodedResponse != [] else {
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
            isLiked: false,
            id: response.id,
            images: response.images
        )
        
        return nft
    }
    
    // Fetching requests
    private func fetchUsersList(pageNumber: Int) async throws -> (Data, URLResponse) {
        guard let request = createUsersListRequest(pageNumber: pageNumber) else {
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
    
    // Creating requests
    private func createUsersListRequest(pageNumber: Int) -> URLRequest? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/api/v1/users"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "size", value: "\(usersListPageSize)"),
            //URLQueryItem(name: "sortBy", value: "rating,asc")
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
    
}


