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
        urlRequest.setValue("6fe3b0b3-4795-4199-a00d-e90e16f22517", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
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
        urlRequest.setValue("6fe3b0b3-4795-4199-a00d-e90e16f22517", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))  // Сообщаем об ошибке
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))  // Сообщаем об ошибке
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))  // Сообщаем об ошибке
                return
            }
            
            do {
                let nftResponse = try JSONDecoder().decode(OrdersCartModel.self, from: data)
                completion(.success(nftResponse))  // Сообщаем об успешном выполнении запроса и передаем результат
            } catch {
                completion(.failure(error))  // Сообщаем об ошибке при декодировании данных
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

    
    func sendPutRequest(nfts: [String], id: String) {
        let baseURL = RequestConstants.baseURL
        let endpoint = "/api/v1/orders/1"
        guard let url = URL(string: baseURL + endpoint) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.accessToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        let ordersCartModel = OrdersCartModel(nfts: nfts, id: id)

        do {
            let jsonData = try JSONEncoder().encode(ordersCartModel)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    print("PUT request successful")
                } else {
                    print("PUT request failed with status code: \(httpResponse.statusCode)")
                }
            }
            task.resume()
        } catch {
            print("Error encoding request body: \(error.localizedDescription)")
        }
    }
}
    
