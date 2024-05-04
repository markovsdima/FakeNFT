import Foundation

protocol StatisticsViewDelegate: NSObjectProtocol {
    func displayUsersList(users: ([StatisticsUser]))
    func loadNextPage(users: ([StatisticsUser]))
    func showLoadingIndicator(_: Bool)
    func showSortActionSheet(alertModel: StatisticsAlertViewModel)
}

protocol StatisticsPresenterProtocol: AnyObject {
    func statisticsViewOpened()
    func loadNextPage()
    func didTapSortButton()
    func getUsersCount() -> Int
    func getUsers() -> [StatisticsUser]
    func checkPagesOut() -> Bool
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    private let networkManager = StatisticsNetworkManager.shared
    private var users: [StatisticsUser] = []
    private var page = 0
    private var pagesOut = false
    
    weak private var view: StatisticsViewDelegate?
    
    func setViewDelegate(statisticsViewDelegate: StatisticsViewDelegate?) {
        self.view = statisticsViewDelegate
    }
    
    @MainActor
    func statisticsViewOpened() {
        Task {
            do {
                self.view?.showLoadingIndicator(true)
                
                let result = try await self.networkManager.getUsersListFromResponse(page: 0)
                users += result
                page += 1
                
                self.view?.showLoadingIndicator(false)
                self.view?.displayUsersList(users: users)
                
            } catch StatisticsNetworkManagerError.emptyResponse {
                
                pagesOut = true
                self.view?.showLoadingIndicator(false)
                
            } catch {
                print("Error loading next page: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func loadNextPage() {
        Task {
            do {
                self.view?.showLoadingIndicator(true)
                
                let result = try await self.networkManager.getUsersListFromResponse(page: page)
                users += result
                page += 1
                
                self.view?.showLoadingIndicator(false)
                self.view?.loadNextPage(users: users)
                
            } catch StatisticsNetworkManagerError.emptyResponse {
                
                pagesOut = true
                self.view?.showLoadingIndicator(false)
                
            } catch {
                print("Error loading next page: \(error.localizedDescription)")
            }
        }
    }
    
    func didTapSortButton() {
        
        let actions: [StatisticsAlertActionViewModel] = [
            StatisticsAlertActionViewModel(
                title: NSLocalizedString("Statistics.sort.byName", comment: ""),
                action: {}
            ),
            StatisticsAlertActionViewModel(
                title: NSLocalizedString("Statistics.sort.byRating", comment: ""),
                action: {}
            )
        ]
        
        let alertModel = StatisticsAlertViewModel(
            title: nil,
            message: NSLocalizedString("Statistics.sort", comment: ""),
            cancelAction: true,
            actions: actions
        )
        
        view?.showSortActionSheet(alertModel: alertModel)
    }
    
    func getUsersCount() -> Int {
        return users.count
    }
    
    func getUsers() -> [StatisticsUser] {
        return users
    }
    
    func checkPagesOut() -> Bool {
        return pagesOut
    }
    
}
