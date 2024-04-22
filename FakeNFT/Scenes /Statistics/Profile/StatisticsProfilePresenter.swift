import Foundation

protocol StatisticsProfileViewDelegate: NSObjectProtocol {
    func displayProfileInfo(user: (StatisticsUserAdvanced))
    func showLoadingIndicator(_: Bool)
}

final class StatisticsProfilePresenter {
    private let networkManager: StatisticsNetworkManager
    private var servicesAssembly: ServicesAssembly!
    weak private var statisticsProfileViewDelegate: StatisticsProfileViewDelegate?
    
    init(networkManager: StatisticsNetworkManager) {
        self.networkManager = networkManager
    }
    
    func setViewDelegate(statisticsProfileViewDelegate: StatisticsProfileViewDelegate?) {
        self.statisticsProfileViewDelegate = statisticsProfileViewDelegate
    }
    
    @MainActor
    func statisticsProfileViewOpened(userId: String?) {
        guard let userId else {
            return
        }
        
        Task {
            do {
                self.statisticsProfileViewDelegate?.showLoadingIndicator(true)
                
                let userInfo = try await networkManager.getUserInfoFromResponse(id: userId)
                self.statisticsProfileViewDelegate?.displayProfileInfo(user: userInfo)
                
                self.statisticsProfileViewDelegate?.showLoadingIndicator(false)
            } catch {
                print("statisticsProfileViewOpened method error. Error: \(error.localizedDescription)")
            }
        }
        
    }
}
