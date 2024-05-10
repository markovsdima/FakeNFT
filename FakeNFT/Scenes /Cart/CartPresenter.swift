import Foundation

//import UIKit

protocol CartPreseterView: AnyObject {
    var totalPrice: String { get set }
    var nftDataCount: Int { get set }
}

final class CartPresenter {
    // MARK: - Properties
    weak var view: CartPreseterView?
    
    var nftData: [NFTCartModel] = [NFTCartModel(name: "Apec",
                                                image: "ApecoinCart",
                                                rating: 1,
                                                paymentSystem: "Apecoin",
                                                currency: "APE",
                                                price: 7,
                                                id: UUID()),
                                   NFTCartModel(name: "Bit",
                                                image: "BitcoinCart",
                                                rating: 3,
                                                paymentSystem: "Bitcoin",
                                                currency: "ВТС",
                                                price: 2,
                                                id: UUID())]
    
    var totalPrice: Double = 0
    var nftDataCount = 0
    
    init(view: CartPreseterView) {
        self.view = view
    }
    
    // MARK: - Lifecycle
    func nftCount() {
        nftDataCount = 0
        nftDataCount = nftData.count
        view?.nftDataCount = nftDataCount
    }
    
    func deleteNFT() {
        totalPrice = 0
        nftData.removeAll()
        view?.totalPrice = String(totalPrice)
    }
    
    func sumNFT() {
        for newPrice in nftData {
            totalPrice += newPrice.price
        }
        view?.totalPrice = String(totalPrice)
    }
}
