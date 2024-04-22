import Foundation

protocol StatisticsCollectionViewDelegate: NSObjectProtocol {
    func displayCollection(collection: ([StatisticsNFTCell]))
    func showLoadingIndicator(_: Bool)
}

final class StatisticsCollectionPresenter {
    private var servicesAssembly: ServicesAssembly!
    private let networkManager: StatisticsNetworkManager
    
    weak private var statisticsCollectionViewDelegate: StatisticsCollectionViewDelegate?
    
    init(networkManager: StatisticsNetworkManager) {
        self.networkManager = networkManager
    }
    
    func setViewDelegate(statisticsCollectionViewDelegate: StatisticsCollectionViewDelegate?) {
        self.statisticsCollectionViewDelegate = statisticsCollectionViewDelegate
    }
    
    func statisticsCollectionViewOpened(nfts: [String]) {
        Task {
            do {
                self.statisticsCollectionViewDelegate?.showLoadingIndicator(true)
                
                let result = try await networkManager.getNftsFromResponses(nftsIds: nfts)
                self.statisticsCollectionViewDelegate?.displayCollection(collection: result)
                
                self.statisticsCollectionViewDelegate?.showLoadingIndicator(false)
            } catch {
                print("statisticsCollectionViewOpened method error. Error: \(error.localizedDescription)")
            }
        }
        
    }
}
