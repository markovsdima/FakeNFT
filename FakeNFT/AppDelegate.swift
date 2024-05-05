import UIKit
import ProgressHUD

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UITabBar.appearance().unselectedItemTintColor = .ypBlack
        UITabBar.appearance().tintColor = .ypBlueUniversal
        
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorHUD = .ypWhite ?? .white
        ProgressHUD.colorAnimation = .ypBlack ?? .black
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
