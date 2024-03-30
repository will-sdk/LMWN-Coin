
import UIKit

protocol DetailNavigator {
    func toCitySearch()
}

final class DefaultDetailNavigator: DetailNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toCitySearch() {
        navigationController.popViewController(animated: true)
    }
}
