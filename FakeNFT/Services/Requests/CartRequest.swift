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
