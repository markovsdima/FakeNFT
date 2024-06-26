import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    weak var returnDelegate: ReturnDelegate?
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "TabBar/profile"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "TabBar/catalog"),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "TabBar/cart"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "TabBar/statistics"),
        tag: 3
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )
        let networkClient = DefaultNetworkClient()
        let profileService = ProfileServiceImpl(
            networkClient: networkClient
        )
        let profilePresenter = ProfilePresenter(
            service: profileService,
            profileId: ProfileConstants.profileId
        )
        profileController.presenter = profilePresenter
        profilePresenter.profileView = profileController
                
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        
        profileController.tabBarItem = profileTabBarItem
        
        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = CartViewController(
            servicesAssembly: servicesAssembly
        )
        
        cartController.tabBarItem = cartTabBarItem
        
        let statistisPresenter = StatisticsPresenter()
        let statisticsController = StatisticsViewController(presenter: statistisPresenter)
        statistisPresenter.setViewDelegate(statisticsViewDelegate: statisticsController)
        
        statisticsController.tabBarItem = statisticsTabBarItem
        
        viewControllers = [profileNavigationController, catalogController, cartController, statisticsController]
        
        view.backgroundColor = .ypWhite
        
        cartController.returnDelegate = self
    }
}


extension TabBarController: BlurViewDelegate {
    func activatingBlurView(_ activating: Bool) {
        if activating {
            if let tabBarSubviews = self.tabBar.subviews as? [UIView] {
                for subview in tabBarSubviews {
                    subview.isHidden = true
                }
            }
        } else {
            if let tabBarSubviews = self.tabBar.subviews as? [UIView] {
                for subview in tabBarSubviews {
                    subview.isHidden = false
                }
            }
        }
    }
}

extension TabBarController: ReturnDelegate {
    func returnToTabBar() {
        self.dismiss(animated: true)
        guard let controllers = viewControllers, controllers.indices.contains(1) else { return }

        if let catalogController = controllers[1] as? CatalogViewController {
            self.selectedIndex = 1
        }
    }
}
