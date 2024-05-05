import Foundation

protocol MyNFTVPresenterProtocol {
    
    var view: MyNFTViewControllerProtocol? { get set }
    
    func loadNfts()
}

final class MyNFTPresenter: MyNFTVPresenterProtocol {
    
    weak var view: MyNFTViewControllerProtocol?
    
    private let nftService: NftService
    
    private let myNftsIds: [String]
    
    private var nfts: [MyNFT] = []

    init(
        myNftsIds: [String],
        view: MyNFTViewControllerProtocol,
        nftService: NftService
    ) {
        self.myNftsIds = myNftsIds
        
        self.view = view
        self.nftService = nftService
    }
    
    func loadNfts() {
        if myNftsIds.isEmpty {
            view?.refreshNfts(nfts: nfts)
            
        } else {
            view?.setLoader(visible: true)
            
            view?.refreshNfts(nfts: mockMyNfts)
        }
    }
}
