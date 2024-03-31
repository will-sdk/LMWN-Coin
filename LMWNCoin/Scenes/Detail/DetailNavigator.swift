
import UIKit

protocol DetailNavigator {
    func toDashboard()
}

final class DefaultDetailNavigator: DetailNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toDashboard() {
        navigationController.popViewController(animated: true)
    }
}
