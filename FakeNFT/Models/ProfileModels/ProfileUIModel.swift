import UIKit

struct ProfileUIModel {
    var name: String
    var avatar: URL?
    var description: String
    var website: URL?
    var nfts: [String]
    var likes: [String]
    var id: String
    
    
    init(from responseModel: ProfileResponse) {
        name = responseModel.name
        avatar = responseModel.avatar
        description = responseModel.description
        website = responseModel.website
        nfts = responseModel.nfts
        likes = responseModel.likes
        id = responseModel.id
    }
    
    init(name: String, avatar: URL, description: String, website: URL, nfts: [String], likes: [String], id: String) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.likes = likes
        self.id = id
    }
}

