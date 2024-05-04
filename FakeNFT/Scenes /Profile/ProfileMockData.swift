import Foundation

struct MyNFT {
    let imageUrl: String?
    let isLiked: Bool
    let name: String
    let rating: Int
    let price: Float
    let author: String
}

//let mockMyNfts: [MyNFT] = []

let mockMyNfts = [
    MyNFT(
        imageUrl: "https://printstorm.ru/wp-content/uploads/2021/08/pokemon-07-1024x1024.jpg",
        isLiked: true,
        name: "Lilo",
        rating: 3,
        price: 1.78,
        author: "John Doe"
    ),
    MyNFT(
        imageUrl: "https://staticg.sportskeeda.com/wp-content/uploads/2016/09/eevee-1474440362-800.jpg",
        isLiked: false,
        name: "Spring",
        rating: 3,
        price: 1.78,
        author: "John Doe"
    ),
    MyNFT(
        imageUrl: "https://yobte.ru/uploads/posts/2019-11/pokemony-42-foto-35.png",
        isLiked: false,
        name: "April",
        rating: 3,
        price: 1.78,
        author: "John Doe"
    ),
]

struct FavouriteNFT {
    let imageUrl: String?
    let isLiked: Bool
    let name: String
    let rating: Int
    let price: Float
}

//let mockFavouriteNfts: [FavouriteNFT] = []

let mockFavouriteNfts = [
    FavouriteNFT(
        imageUrl: "https://printstorm.ru/wp-content/uploads/2021/08/pokemon-07-1024x1024.jpg",
        isLiked: true,
        name: "Archie",
        rating: 1,
        price: 1.78
    ),
    FavouriteNFT(
        imageUrl: "https://staticg.sportskeeda.com/wp-content/uploads/2016/09/eevee-1474440362-800.jpg",
        isLiked: true,
        name: "Pixi",
        rating: 3,
        price: 1.78
    ),
    FavouriteNFT(
        imageUrl: "https://yobte.ru/uploads/posts/2019-11/pokemony-42-foto-35.png",
        isLiked: true,
        name: "Melissa",
        rating: 5,
        price: 1.78
    ),
    FavouriteNFT(
        imageUrl: "https://i.pinimg.com/originals/cd/8a/13/cd8a13b918337e918973242208084ebf.jpg",
        isLiked: true,
        name: "April",
        rating: 2,
        price: 1.78
    ),
]

//MARK: - Strings for labels

enum ProfileConstants {
    static let profileId = "1"
    static let profileNameString = "Joaquin Phoenix"
    static let profileBioString = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    static let profileWebLinkString = "Joaquin Phoenix.com"
    static let developerLink = "https://phoenix.com"
}

