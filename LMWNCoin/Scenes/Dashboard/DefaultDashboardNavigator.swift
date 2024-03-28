
import UIKit
import UseCases
import SafariServices

protocol DashboardNavigator {
    func toDetail(_ coin: Coins)
}

class DefaultDashboardNavigator: DashboardNavigator {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let usecase: UseCaseProvider
    
    init(navigationController: UINavigationController,
         storyBoard: UIStoryboard,
         usecase: UseCaseProvider) {
        self.navigationController = navigationController
        self.storyBoard = storyBoard
        self.usecase = usecase
    }

    func toFixture() {
        let vc = storyBoard.instantiateViewController(ofType: DashboardViewController.self)
        vc.viewModel = DashboardViewModel(navigator: self, usecase: usecase.makeListOfCoinsUseCase())
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toDetail(_ coin: Coins) {
        
    }
}
