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


struct PayCartRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            return nil
        }
        return baseURL.appendingPathComponent("api/v1/orders/1/payment/\(id)")
    }
}

struct GETProfileCart: NetworkRequest {
    var endpoint: URL? {
        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            return nil
        }
        return baseURL.appendingPathComponent("api/v1/profile/1")
    }
}
