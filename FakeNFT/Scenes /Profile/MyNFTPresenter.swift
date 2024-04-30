import Foundation

protocol MyNFTVPresenterProtocol {
    
    var view: MyNFTViewControllerProtocol? { get set }
    
    func loadNfts()
}

class MyNFTPresenter: MyNFTVPresenterProtocol {
    
    var view: MyNFTViewControllerProtocol?

    func loadNfts() {
        view?.refreshNfts(nfts: mockMyNfts)
    }
}
