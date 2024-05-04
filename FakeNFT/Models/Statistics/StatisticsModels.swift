import UIKit

// MARK: - View Models
struct StatisticsUser {
    let name: String
    let score: Int
    let rating: String
    let id: String
    let avatar: String
}

struct StatisticsUserAdvanced {
    let name: String
    let avatar: String
    let description: String
    let nftsCount: Int
    let website: String
    let nfts: [String]
}

struct StatisticsNFTCell: Hashable {
    let name: String
    let price: Float
    let rating: Int
    let isLiked: Bool
    let id: String
    let images: [String]
}

struct StatisticsAlertViewModel {
    let title: String?
    let message: String?
    let cancelAction: Bool
    let actions: [StatisticsAlertActionViewModel]
}

struct StatisticsAlertActionViewModel {
    let title: String
    let action: () -> Void
}

// MARK: - Network Models
struct StatisticsUserListResponse: Decodable, Equatable {
    let name: String
    let avatar: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}

struct StatisticsUserResponse: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let id: String
}

struct StatisticsNFTResponse: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let id: String
}
