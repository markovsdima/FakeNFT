import Foundation

protocol StatisticsProfileViewDelegate: NSObjectProtocol {
    func displayProfileInfo(user: (StatisticsUserAdvanced))
    func showLoadingIndicator(_: Bool)
    func openWebView(website: String)
    func openNftCollection(nfts: [String])
}

protocol StatisticsProfilePresenterProtocol: AnyObject {
    func statisticsProfileViewOpened()
    func didTapSiteButton()
    func didTapNftCollectionButton()
}

final class StatisticsProfilePresenter: StatisticsProfilePresenterProtocol {
    private let networkManager: StatisticsNetworkManager
    private var user: StatisticsUserAdvanced?
    private let userId: String?
    weak private var view: StatisticsProfileViewDelegate?
    
    init(networkManager: StatisticsNetworkManager, userId: String) {
        self.networkManager = networkManager
        self.userId = userId
    }
    
    func setViewDelegate(statisticsProfileViewDelegate: StatisticsProfileViewDelegate?) {
        self.view = statisticsProfileViewDelegate
    }
    
    @MainActor
    func statisticsProfileViewOpened() {
        guard let userId else {
            return
        }
        
        Task {
            do {
                self.view?.showLoadingIndicator(true)
                
                let userInfo = try await networkManager.getUserInfoFromResponse(id: userId)
                self.user = userInfo
                guard let user else { return }
                self.view?.displayProfileInfo(user: user)
                
                self.view?.showLoadingIndicator(false)
            } catch {
                print("statisticsProfileViewOpened method error. Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func didTapSiteButton() {
        guard let website = user?.website else { return }
        view?.openWebView(website: website)
    }
    
    func didTapNftCollectionButton() {
        guard let nfts = user?.nfts else { return }
        view?.openNftCollection(nfts: nfts)
    }
}
