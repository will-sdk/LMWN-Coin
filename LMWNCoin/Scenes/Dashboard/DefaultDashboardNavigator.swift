
import UIKit
import UseCases
import SafariServices

protocol DashboardNavigator {
    func toDetail(_ dashboardItemViewModel: DashboardItemViewModel?)
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
    
    func toDetail(_ dashboardItemViewModel: DashboardItemViewModel?) {
        let navigator = DefaultDetailNavigator(navigationController: navigationController)
        let viewModel = DetailViewModel(dashboardItem: dashboardItemViewModel, navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: DetailViewController.self)
        vc.viewModel = viewModel
        navigationController.present(vc, animated: true)
    }
}
