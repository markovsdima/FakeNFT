import Foundation

final class CurrencyService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCurrencies(completion: @escaping (Result<[PaymentSystemModel], Error>) -> Void) {
        let request = CurrenciesRequest()
        networkClient.send(request: request, type: [PaymentSystemModel].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
