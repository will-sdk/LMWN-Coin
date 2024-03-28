
import UIKit
import UseCases
import Repositories

final class Application {
    static let shared = Application()
    
    private let useCaseProvider: UseCases.UseCaseProvider
    
    private init() {
        self.useCaseProvider = Repositories.UseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let footballNavigationController = UINavigationController()
        footballNavigationController.tabBarItem = UITabBarItem(title: "Football",
                                                               image: UIImage(named: "Box"),
                                                               selectedImage: nil)
        
        let footballNavigator = DefaultDashboardNavigator(
            navigationController: footballNavigationController,
            storyBoard: storyboard,
            usecase: useCaseProvider)
        
        let tennisNavigationController = UINavigationController()
        tennisNavigationController.tabBarItem = UITabBarItem(title: "Tennis",
                                                             image: UIImage(named: "Toolbox"),
                                                             selectedImage: nil)
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            footballNavigationController
        ]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        footballNavigator.toFixture()
    }
}
