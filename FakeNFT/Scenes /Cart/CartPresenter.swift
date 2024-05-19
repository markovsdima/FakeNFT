import Foundation

//import UIKit

protocol CartPreseterView: AnyObject {
    func nftData(_ nfts: NFTCartModel)
}

enum SortOption: String {
    case price
    case rating
    case name
}

final class CartPresenter {
    // MARK: - Properties
    weak var view: CartPreseterView?
    
    private var numbersNFTs = ["90", "91", "92", "93"]
    init(view: CartPreseterView) {
        self.view = view
    }
    
    // MARK: - Lifecycle
    func deleteNFT() {
        
    }
//    func fetchNFTCart() {
//        CartNetworkClient.shared.fetchNftIdCart(IdNFTs: numbersNFTs) { result in
//            switch result {
//            case .success(let nfts):
//                if let firstNft = nfts.first {
//                    self.view?.nftData(firstNft)
//                } else {
//                    // Обработка ситуации, когда массив пуст
//                }
//            case .failure(let error):
//                print("Error fetching payment systems: (error.localizedDescription)")
//            }
//        }
//    }
//
    func fetchNFTCart() {
        CartNetworkClient.shared.fetchNftIdCart(IdNFTs: numbersNFTs) { result in
            switch result {
            case .success(let nft):
                self.view?.nftData(nft)
            case .failure(let error):
                print("Error fetching payment systems: \(error.localizedDescription)")
            }
        }
    }
//    
    func fetchOrdersCart() {
//        CartNetworkClient.shared.fetchOrdersCart { result in
//            switch result {
//            case .success(let order):
//                print(order)
//            case .failure(let error):
//                print("Error fetching payment systems: \(error.localizedDescription)")
//            }
//        }
    }
}
