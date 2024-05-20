import Foundation

//import UIKit

protocol CartView: AnyObject {
    func collection()
}

enum SortOption: String {
    case price
    case rating
    case name
}

final class CartPresenter {
    // MARK: - Properties
    weak var view: CartView?
    private(set) var nftData = [NFTCartModel]()
    private(set) var numbersNFTs = [String]()
    init(view: CartView) {
        self.view = view
    }
    
    // MARK: - Lifecycle
    
    func deleteNFT(_ nftId: String) {
        print(nftId)
        let id = "b30e685d-7643-4d88-840a-e4506277661d"

        if let index = numbersNFTs.firstIndex(of: nftId) {
            numbersNFTs.remove(at: index)
            CartNetworkClient.shared.sendPutRequest(nfts: numbersNFTs, id: id)
        }
        fetchOrdersCart()
    }
    
    func sortPriceNFTData() {
        nftData = nftData.sorted { $0.price < $1.price }
    }
    
    func sortRatingNFTData() {
        nftData = nftData.sorted { $0.rating < $1.rating }
    }
    
    func sortNameNFTData(){
        nftData = nftData.sorted { $0.name < $1.name }
    }
    
    func fetchOrdersCart() {
        CartNetworkClient.shared.fetchOrdersCart() { result in
            switch result {
            case .success(let nft):
                print(nft)
                self.numbersNFTs = nft.nfts
            case .failure(let error):
                print("Error fetching orders cart: \(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchNFTCart() {
        CartNetworkClient.shared.fetchNftIdCart(IdNFTs: numbersNFTs) { [weak self] result in
            switch result {
            case .success(let nfts):
                print(nfts)
                let sortedNfts = nfts.sorted { $0.name < $1.name }
                self?.nftData.append(contentsOf: sortedNfts)
                DispatchQueue.main.async {
                    self?.view?.collection()
                }
            case .failure(let error):
                print("Error fetching NFT cart: (error.localizedDescription)")
            }
        }
    }


}
