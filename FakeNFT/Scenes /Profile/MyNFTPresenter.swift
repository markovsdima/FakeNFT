import Foundation

protocol MyNFTVPresenterProtocol {
    
    var view: MyNFTViewControllerProtocol? { get set }
    
    
    func loadNfts()
}

final class MyNFTPresenter: MyNFTVPresenterProtocol {
    
    weak var view: MyNFTViewControllerProtocol?
    
//    private let profileService: ProfileService
//    private let nftService: NftService
    
    private var nfts: [Nft] = []

    
    func loadNfts() {
        view?.refreshNfts(nfts: mockMyNfts)
    }
}
