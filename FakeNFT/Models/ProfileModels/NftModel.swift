import Foundation

struct NftModel {
    let name: String
    let images: [String]
    let rating: Int
    let description: String?//todo delete
    let price: Float
    let author: String
    let id: String
    
    init(name: String, images: [String], rating: Int, description: String?, price: Float, author: String, id: String) {
        self.name = name
        self.images = images
        self.rating = rating
        self.description = description
        self.price = price
        self.author = author
        self.id = id
    }
    
    init(_ response: NftResponse) {
        self.name = response.name
        self.images = response.images
        self.rating = response.rating
        self.description = response.description
        self.price = response.price
        self.author = response.author
        self.id = response.id
    }
}
