import Foundation

struct PaymentSystemModel: Decodable {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct PayCartModel: Decodable, Equatable {
    let success: Bool
    let orderId: String
    let id: String
}
