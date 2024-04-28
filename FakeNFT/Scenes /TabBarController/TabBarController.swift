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
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "TabBar/cart"),
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "TabBar/statistics"),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )
        
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
        
        let statisticsController = StatisticsViewController(
            servicesAssembly: servicesAssembly
        )
        
        statisticsController.tabBarItem = statisticsTabBarItem
        
        viewControllers = [profileNavigationController, catalogController, cartController, statisticsController]
        
        view.backgroundColor = .systemBackground
    }
}
