import Foundation

protocol FavouriteNFTPresenterProtocol {
    
    var view: FavouriteNFTViewControllerProtocol? { get set }
    
    func loadNfts()
}

class FavouriteNFTPresenter: FavouriteNFTPresenterProtocol {
    
    var view: FavouriteNFTViewControllerProtocol?

    func loadNfts() {
        view?.refreshNfts(nfts: mockFavouriteNfts)
    }
}
