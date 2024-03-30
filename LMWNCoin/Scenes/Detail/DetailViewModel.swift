
import UseCases
import RxSwift
import RxCocoa

final class DetailViewModel {
    private let dashboardItem: DashboardItemViewModel?
    private let navigator: DetailNavigator
    
    init(dashboardItem: DashboardItemViewModel?, navigator: DetailNavigator) {
        self.dashboardItem = dashboardItem
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let dashboardItem = input.trigger
            .map { [weak self] in
                self?.dashboardItem ?? DashboardItemViewModel(with: nil, isQuery: false) }
            .asDriver(onErrorJustReturn: DashboardItemViewModel(with: nil, isQuery: false))
        
        return Output(dashboardItem: dashboardItem)
    }
}

extension DetailViewModel {
    struct Input {
        let trigger: Driver<Void>
    }

    struct Output {
        let dashboardItem: Driver<DashboardItemViewModel>
    }
}
