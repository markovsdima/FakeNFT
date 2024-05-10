import Foundation

public struct ProfileRequest: Codable {
    var name: String
    var avatar: String?
    var description: String
    var website: String?
    var likes: [String]

    init(name: String, avatar: String, description: String, website: String, likes: [String]) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.likes = likes
    }

    init(from profileModel: ProfileUIModel) {
        name = profileModel.name
        avatar = profileModel.avatar?.absoluteString
        description = profileModel.description
        website = profileModel.website?.absoluteString
        likes = profileModel.likes
    }

}
