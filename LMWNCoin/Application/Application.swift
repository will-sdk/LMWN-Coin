
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
        
        let dashboardNavigationController = UINavigationController()
        
        let dashboardNavigator = DefaultDashboardNavigator(
            navigationController: dashboardNavigationController,
            storyBoard: storyboard,
            usecase: useCaseProvider)
        
        window.rootViewController = dashboardNavigationController
        window.makeKeyAndVisible()
        dashboardNavigator.toFixture()
    }
}
