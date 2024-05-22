import Foundation

protocol CartView: AnyObject {
    func collection()
    func activityIndicator(_ activity: Bool)
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
    private func saveSortingOption(_ key: String) {
        UserDefaults.standard.set(key, forKey: "lastSortingOption")
        view?.collection()
    }
    
    private func applyLastSavedSorting() {
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
    
    func fetchOrdersCart() {
        CartNetworkClient.shared.fetchOrdersCart() { result in
            switch result {
            case .success(let nfts):
                self.view?.activityIndicator(false)
                self.numbersNFTs = nfts.nfts
                print("Request completed successfully")
                self.fetchNFTCart()
                self.view?.collection()
                self.view?.activityIndicator(true)
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
    
    func deleteNFT(_ nftId: String) {
        if let index = numbersNFTs.firstIndex(of: nftId) {
            numbersNFTs.remove(at: index)
        }
        
        CartNetworkClient.shared.sendPutRequest(numbersNFTs)
        fetchNFTCart()
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
}
