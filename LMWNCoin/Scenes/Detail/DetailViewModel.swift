
import UseCases
import RxSwift
import RxCocoa

final class DetailViewModel {
    private let dashboardItem: DashboardItemModel?
    private let navigator: DetailNavigator
    
    init(dashboardItem: DashboardItemModel?, navigator: DetailNavigator) {
        self.dashboardItem = dashboardItem
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let dashboardItem = input.trigger
            .map { [weak self] in
                self?.dashboardItem ?? DashboardItemModel(with: nil, isQuery: false) }
            .asDriver(onErrorJustReturn: DashboardItemModel(with: nil, isQuery: false))
        
        return Output(dashboardItem: dashboardItem)
    }
}

extension DetailViewModel {
    struct Input {
        let trigger: Driver<Void>
    }

    struct Output {
        let dashboardItem: Driver<DashboardItemModel>
    }
}
