import Foundation

protocol StatisticsCollectionViewDelegate: NSObjectProtocol {
    func displayCollection(collection: ([StatisticsNFTCell]))
    func showLoadingIndicator(_: Bool)
}

protocol StatisticsCollectionPresenterProtocol: AnyObject {
    func statisticsCollectionViewOpened()
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
                guard let nfts else { return }
                self.view?.showLoadingIndicator(true)
                
                let result = try await networkManager.getNftsFromResponses(nftsIds: nfts)
                self.view?.displayCollection(collection: result)
                
                self.view?.showLoadingIndicator(false)
            } catch {
                print("statisticsCollectionViewOpened method error. Error: \(error.localizedDescription)")
            }
        }
        
    }
}
