import Foundation

protocol FavouriteNFTPresenterProtocol {
    
    var view: FavouriteNFTViewControllerProtocol? { get set }
    
    func loadNfts()
}

final class FavouriteNFTPresenter: FavouriteNFTPresenterProtocol {
    
    weak var view: FavouriteNFTViewControllerProtocol?
    
    func loadNfts() {
        view?.refreshNfts(nfts: mockFavouriteNfts)
    }
}
