
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
        
        let footballNavigator = DefaultDashboardNavigator(
            navigationController: footballNavigationController,
            storyBoard: storyboard,
            usecase: useCaseProvider)
        
        window.rootViewController = footballNavigationController
        window.makeKeyAndVisible()
        footballNavigator.toFixture()
    }
}
