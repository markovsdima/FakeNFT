import Foundation

public struct ProfileResponse: Codable {
    var name: String
    var avatar: URL?
    var description: String
    var website: URL?
    var nfts: [String]
    var likes: [String]
    var id: String
}
