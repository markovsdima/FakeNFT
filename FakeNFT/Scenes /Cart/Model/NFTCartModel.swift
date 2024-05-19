import Foundation

struct NFTCartModel: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let id: String
}


struct OrdersCartModel: Decodable {
    let nfts: [String]
    let id: String
}

extension NFTCartModel {
    static func generateMockData() -> [NFTCartModel] {
        // Здесь можешь сгенерировать или хардкодом задать свои mock данные для тестирования
        return [
            NFTCartModel(name: "Item 1", images: ["image1.png"], rating: 4, price: 10.99, id: "1"),
            NFTCartModel(name: "Item 2", images: ["image2.png"], rating: 3, price: 9.99, id: "2"),
            NFTCartModel(name: "Item 3", images: ["image3.png"], rating: 5, price: 15.99, id: "3")
        ]
    }
}
