import Foundation

protocol StatisticsCollectionViewDelegate: NSObjectProtocol {
    func displayCollection(collection: ([StatisticsNFTCell]))
    func showLoadingIndicator(_: Bool)
    func displayEmptyCollection()
}

protocol StatisticsCollectionPresenterProtocol: AnyObject {
    func statisticsCollectionViewOpened()
    func didTapLikeButton(id: String)
    func didTapOrderButton(id: String)
}

final class StatisticsCollectionPresenter: StatisticsCollectionPresenterProtocol {
    
    private let networkManager: StatisticsNetworkManager
    private let nfts: [String]?
    
    weak private var view: StatisticsCollectionViewDelegate?
    
    init(networkManager: StatisticsNetworkManager, nfts: [String]) {
        self.networkManager = networkManager
        self.nfts = nfts
    }
    
    func setViewDelegate(statisticsCollectionViewDelegate: StatisticsCollectionViewDelegate?) {
        self.view = statisticsCollectionViewDelegate
    }
    
    func statisticsCollectionViewOpened() {
        Task {
            do {
                try await networkManager.getMyNftLikes()
                try await networkManager.getCartNfts()
                guard let nfts else { return }
                
                if nfts == [] {
                    view?.displayEmptyCollection()
                } else {
                    view?.showLoadingIndicator(true)
                    let result = try await networkManager.getNftsFromResponses(nftsIds: nfts)
                    view?.displayCollection(collection: result)
                    view?.showLoadingIndicator(false)
                }
            } catch {
                print("statisticsCollectionViewOpened method error. Error: \(error.localizedDescription)")
            }
        }
    }
    
    func didTapLikeButton(id: String) {
        Task {
            try await networkManager.updateNftLike(nftId: id)
        }
    }
    
    func didTapOrderButton(id: String) {
        Task {
            try await networkManager.updateCart(nftId: id)
        }
    }
}
