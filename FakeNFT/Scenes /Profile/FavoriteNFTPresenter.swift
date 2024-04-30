import Foundation

protocol FavoriteNFTPresenterProtocol {
    
    var view: FavoriteNFTViewControllerProtocol? { get set }
    
    func loadNfts()
}

class FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {
    
    var view: FavoriteNFTViewControllerProtocol?

    func loadNfts() {
        view?.refreshNfts(nfts: mockFavoriteNfts)
    }
}
