import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
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
        profileController.tabBarItem = profileTabBarItem
        profileController.tabBarItem.accessibilityIdentifier = "ProfileTab"
        
        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        catalogController.tabBarItem.accessibilityIdentifier = "CatalogTab"
        
        let cartController = CartViewController(
            servicesAssembly: servicesAssembly
        )
        cartController.tabBarItem = cartTabBarItem
        cartController.tabBarItem.accessibilityIdentifier = "CartTab"
        
        let statisticsController = StatisticsViewController(
            servicesAssembly: servicesAssembly
        )
        statisticsController.tabBarItem = statisticsTabBarItem
        statisticsController.tabBarItem.accessibilityIdentifier = "StatisticsTab"
        
        viewControllers = [profileController, catalogController, cartController, statisticsController]
        
        view.backgroundColor = .systemBackground
    }
}
