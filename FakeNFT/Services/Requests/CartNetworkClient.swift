import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

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
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(RequestConstants.accessToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        session.dataTask(with: urlRequest) { data, response, error in
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
    
    func fetchOrdersCart(completion: @escaping (Result<OrdersCartModel, Error>) -> Void) {
        let request = OrdersRequest()
        
        guard let url = request.endpoint else {
            completion(.failure(NetworkError.invalidURL))  // Сообщаем о неудаче
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(RequestConstants.accessToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
                let nftResponse = try JSONDecoder().decode(OrdersCartModel.self, from: data)
                completion(.success(nftResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchNftIdCart(IdNFTs: [String], completion: @escaping (Result<[NFTCartModel], Error>) -> Void) {
        var nftCarts: [NFTCartModel] = []
        let dispatchGroup = DispatchGroup()
        var lastError: Error?
        
        for nftId in IdNFTs {
            dispatchGroup.enter()
            let request = NFTRequest(id: nftId)
            
            guard let url = request.endpoint else {
                lastError = NetworkError.invalidURL
                dispatchGroup.leave()
                continue
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("6fe3b0b3-4795-4199-a00d-e90e16f22517", forHTTPHeaderField: "X-Practicum-Mobile-Token")
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    lastError = error
                } else if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(NFTCartModel.self, from: data)
                        nftCarts.append(decodedData)
                    } catch {
                        lastError = error
                    }
                } else {
                    lastError = NetworkError.invalidResponse
                }
                dispatchGroup.leave()
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = lastError {
                completion(.failure(error))
            } else {
                completion(.success(nftCarts))
            }
        }
    }

    func sendPutRequest(_ nfts: [String]) {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.accessToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
    
        let nftsString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        let bodyString = nftsString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making PUT request: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("PUT request response status code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data: \(dataString)")
            }
        }
        task.resume()
    }
}
