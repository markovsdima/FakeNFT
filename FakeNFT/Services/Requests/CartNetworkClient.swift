import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
//class CartNetworkClient {
//    static let shared = CartNetworkClient()
//    
//    private let session: URLSession
//    
//    private init() {
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 20
//        session = URLSession(configuration: config)
//    }
//    
//    func fetchPaymentSystems(completion: @escaping (Result<[PaymentSystemModel], Error>) -> Void) {
//        guard let url = CurrenciesRequest().endpoint else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//        
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.addValue(RequestConstants.accessToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
//        
//        session.dataTask(with: urlRequest) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                completion(.failure(NetworkError.invalidResponse))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NetworkError.invalidData))
//                return
//            }
//            
//            do {
//                let decodedData = try JSONDecoder().decode([PaymentSystemModel].self, from: data)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    func fetchNftIdCart(IdNFTs: [String], completion: @escaping (Result<[NFTCartModel], Error>) -> Void) {
//        let dispatchGroup = DispatchGroup()
//        var nftCartModels: [NFTCartModel] = []
//        var hasErrorOccurred: Bool = false
//        
//        for nftId in IdNFTs {
//            dispatchGroup.enter()
//            
//            guard let url = URL(string: "(RequestConstants.baseURL)/api/v1/nft/(nftId)") else {
//                completion(.failure(NetworkError.invalidURL))
//                return
//            }
//            
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = "GET"
//            urlRequest.addValue(RequestConstants.accessToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
//            
//            session.dataTask(with: urlRequest) { data, response, error in
//                defer { dispatchGroup.leave() }
//                
//                if hasErrorOccurred {
//                    return
//                }
//                
//                if let error = error {
//                    hasErrorOccurred = true
//                    completion(.failure(error))
//                    return
//                }
//                
//                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                    hasErrorOccurred = true
//                    completion(.failure(NetworkError.invalidResponse))
//                    return
//                }
//                
//                guard let data = data else {
//                    hasErrorOccurred = true
//                    completion(.failure(NetworkError.invalidData))
//                    return
//                }
//                
//                do {
//                    let decodedData = try JSONDecoder().decode(NFTCartModel.self, from: data)
//                    nftCartModels.append(decodedData)
//                } catch {
//                    hasErrorOccurred = true
//                    completion(.failure(error))
//                }
//            }.resume()
//        }
//        
//        dispatchGroup.notify(queue: .main) {
//            if !hasErrorOccurred {
//                completion(.success(nftCartModels))
//            }
//        }
//    }
//}

class CartNetworkClient {
    static let shared = CartNetworkClient()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        session = URLSession(configuration: config)
    }
    
    func fetchPaymentSystems(completion: @escaping (Result<[PaymentSystemModel], Error>) -> Void) {
        let request = CurrenciesRequest()
        
        guard let url = request.endpoint else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([PaymentSystemModel].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func fetchOrdersCart(completion: @escaping (Result<[OrdersCartModel], Error>) -> Void) {
        let request = OrdersRequest()
        
        guard let url = request.endpoint else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([OrdersCartModel].self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchNftIdCart(IdNFTs: [String], completion: @escaping (Result<NFTCartModel, Error>) -> Void) {
        for nftId in IdNFTs {
            let request = NFTRequest(id: nftId)
            
            guard let url = request.endpoint else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.invalidData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(NFTCartModel.self, from: data)
                    
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
    
