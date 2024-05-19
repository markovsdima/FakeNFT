import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            return nil
        }
        return baseURL.appendingPathComponent("/api/v1/currencies")
    }
}

struct OrdersRequest: NetworkRequest {
    var endpoint: URL? {
        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            return nil
        }
        return baseURL.appendingPathComponent("/api/v1/orders/1")
    }
}


//https://64858e8ba795d24810b71189.mockapi.io/api/v1/orders/1

