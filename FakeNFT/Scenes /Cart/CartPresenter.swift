import Foundation

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
        print("DELNFT \(nftId)")
        //        let id = "b30e685d-7643-4d88-840a-e4506277661d"
        //
        //        if let index = numbersNFTs.firstIndex(of: nftId) {
        //            numbersNFTs.remove(at: index)
        //            view?.collection()
        //        }
        //        print(" NEWARRAY \(numbersNFTs)")
        //
    }
    
    func sortPriceNFTData() {
        nftData = nftData.sorted { $0.price < $1.price }
        saveSortingOption("sortPriceNFTData")
    }
    
    func sortRatingNFTData() {
        nftData = nftData.sorted { $0.rating < $1.rating }
        saveSortingOption("sortRatingNFTData")
    }
    
    func sortNameNFTData(){
        nftData = nftData.sorted { $0.name < $1.name }
        saveSortingOption("sortNameNFTData")
    }
    
    func countNFT() -> String {
        return "\(nftData.count) NFT"
    }
    
    func priceNFT() -> String {
        var totalPrice = 0.0
        
        for newPrice in nftData {
            totalPrice += newPrice.price
        }
        
        let formattedTotalPrice = String(format: "%.2f", totalPrice)
        
        return "\(formattedTotalPrice) ETH"
    }
    
    func fetchOrdersCart() {
        CartNetworkClient.shared.fetchOrdersCart() { result in
            switch result {
            case .success(let nft):
                self.numbersNFTs = nft.nfts
                print("Request completed successfully")
                self.fetchNFTCart()
            case .failure(let error):
                print("there is no response from the server: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchNFTCart() {
        CartNetworkClient.shared.fetchNftIdCart(IdNFTs: numbersNFTs) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.nftData = nfts
                self?.applyLastSavedSorting()
                DispatchQueue.main.async {
                    self?.view?.collection()
                }
            case .failure(_):
                print("Error fetching NFT cart: (error.localizedDescription)")
            }
        }
    }
    
    private func saveSortingOption(_ key: String) {
        UserDefaults.standard.set(key, forKey: "lastSortingOption")
    }
    
    func applyLastSavedSorting() {
        guard let key = UserDefaults.standard.string(forKey: "lastSortingOption") else { return }
        
        switch key {
        case "sortPriceNFTData":
            sortPriceNFTData()
        case "sortRatingNFTData":
            sortRatingNFTData()
        case "sortNameNFTData":
            sortNameNFTData()
        default:
            break
        }
    }
}
