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

struct GETProfileNFTCartModel: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
