import Foundation

protocol StatisticsViewDelegate: NSObjectProtocol {
    func displayUsersList(users: ([StatisticsUser]))
    func loadNextPage(users: ([StatisticsUser]))
    func showLoadingIndicator(_: Bool)
    func stopLoadingPages()
}

final class StatisticsPresenter {
    private let networkManager = StatisticsNetworkManager.shared
    private var servicesAssembly: ServicesAssembly!
    weak private var statisticsViewDelegate: StatisticsViewDelegate?
    
    func setViewDelegate(statisticsViewDelegate: StatisticsViewDelegate?) {
        self.statisticsViewDelegate = statisticsViewDelegate
    }
    
    @MainActor
    func statisticsViewOpened() {
        Task {
            do {
                self.statisticsViewDelegate?.showLoadingIndicator(true)
                
                let result = try await self.networkManager.getUsersListFromResponse(page: 0)
                
                self.statisticsViewDelegate?.showLoadingIndicator(false)
                self.statisticsViewDelegate?.displayUsersList(users: result)
                
            } catch StatisticsNetworkManagerError.emptyResponse {
                
                statisticsViewDelegate?.stopLoadingPages()
                self.statisticsViewDelegate?.showLoadingIndicator(false)
                
            } catch {
                print("Error loading next page: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func loadNextPage(page: Int) {
        Task {
            do {
                self.statisticsViewDelegate?.showLoadingIndicator(true)
                
                let result = try await self.networkManager.getUsersListFromResponse(page: page)
                
                self.statisticsViewDelegate?.showLoadingIndicator(false)
                self.statisticsViewDelegate?.loadNextPage(users: result)
                
            } catch StatisticsNetworkManagerError.emptyResponse {
                
                statisticsViewDelegate?.stopLoadingPages()
                self.statisticsViewDelegate?.showLoadingIndicator(false)
                
            } catch {
                print("Error loading next page: \(error.localizedDescription)")
            }
        }
    }
    
}
