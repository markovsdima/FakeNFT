import Foundation

protocol FavouriteNFTPresenterProtocol {
    
    var view: FavouriteNFTViewControllerProtocol? { get set }
    
    func loadNfts()
}

final class FavouriteNFTPresenter: FavouriteNFTPresenterProtocol {
    
    weak var view: FavouriteNFTViewControllerProtocol?
    
    private let profileNftService: ProfileNftService
    
    private let favoriteNftsIds: [String]
    
    private var loadedNfts: [FavouriteNFT] = []
    
    init(
        favoriteNftsIds: [String],
        view: FavouriteNFTViewControllerProtocol,
        profileNftService: ProfileNftService
    ) {
        self.view = view
        self.profileNftService = profileNftService
        self.favoriteNftsIds = favoriteNftsIds
    }
    
    func loadNfts() {
        if favoriteNftsIds.isEmpty {
            view?.refreshNfts(nfts: loadedNfts)
        } else {
            view?.setLoader(visible: true)
            
            let dispatchGroup = DispatchGroup()

            favoriteNftsIds.forEach { id in
                dispatchGroup.enter()
                profileNftService.loadNft(id: id) { [weak self] result in
                    defer { dispatchGroup.leave() }
                    
                    switch result {
                    case .success(let nft):
                        self?.loadedNfts.append(FavouriteNFT(nft))
                        
                    case .failure(let error):
//                        self?.isNtfsLoaded = false
//                        self?.state = .failed(error)
                        print("Error loading NFT \(id): \(error)")
                    }
                }
            }

            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self else { return }
                
                self.view?.setLoader(visible: false)
                self.refreshLoadedNftsView()
            }
        }
    }
    
    private func refreshLoadedNftsView() {
        view?.refreshNfts(nfts: loadedNfts)
    }
}
