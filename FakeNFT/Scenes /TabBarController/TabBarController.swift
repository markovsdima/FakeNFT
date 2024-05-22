import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private var profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "TabBar/profile"),
        tag: 0
    )
    
    private var catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "TabBar/catalog"),
        tag: 1
    )
    
    private var cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "TabBar/cart"),
        tag: 2
    )
    
    private var statisticsTabBarItem = UITabBarItem(
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
        
        cartController.blurViewDelegate = self
    }
}


extension TabBarController: BlurViewDelegate {
    func activatingBlurView(_ activating: Bool) {
        tabBar.isHidden = activating
//        if let tabBarController = self.tabBarController {
//            if let viewControllers = tabBarController.viewControllers {
//                if let profileViewController = viewControllers.first(where: { $0.title == NSLocalizedString("Tab.profile", comment: "") }) {
//                    profileViewController.tabBarItem.isEnabled = !activating
//                    // or
//                    if let index = viewControllers.firstIndex(of: profileViewController) {
//                        tabBarController.tabBar.items?[index].isEnabled = !activating
//                    }
//                }
//            }
//        }
//        if !activating {
//            // Скрыть заголовок и изображение вкладки "Profile"
////            profileTabBarItem.title = nil
////            profileTabBarItem.image = nil
//            print("NIL")
//        } else {
//            // Показать заголовок и изображение вкладки "Profile"
//            print("TRUE")
//            profileTabBarItem.title = NSLocalizedString("Tab.profile", comment: "")
//            profileTabBarItem.image = UIImage(named: "TabBar/profile")
//        }
    }
}
