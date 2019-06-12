import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor(red: 38/255, green: 94/255, blue: 150/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 38/255, green: 94/255, blue: 150/255, alpha: 0.5)
        return true
    }
}

