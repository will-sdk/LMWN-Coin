
import RxSwift
import RxCocoa
import UseCases

final class DashboardViewModel: ViewModelType {
    
    private var scopeLimit = 10
    private let loadingMoreRelay = BehaviorRelay<Bool>(value: false)
    private let refreshRelay = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let trigger: Driver<Void>
        let loadMore: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let refresh: Driver<Bool>
        let coins: Driver<[DashboardItemViewModel]>
        let selectedCoin: Driver<DashboardItemViewModel>
        let error: Driver<Error>
        let loadingMore: Driver<Bool>
    }
    
    private let navigator: DashboardNavigator
    private let usecase: ListOfCoinsUseCase
    
    init(navigator: DashboardNavigator,
         usecase: ListOfCoinsUseCase) {
        self.navigator = navigator
        self.usecase = usecase
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let initialCoins = input.trigger.flatMapLatest {
            self.refreshRelay.accept(true)
            return self.usecase.listOfCoins(scopeLimit: "10", search: "")
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { DashboardItemViewModel(with: $0) } }
        }
        
        let nextPageCoins = input.loadMore.flatMapLatest {
            self.scopeLimit += 10
            self.loadingMoreRelay.accept(true)
            self.refreshRelay.accept(false)
            return self.usecase.listOfCoins(scopeLimit: "\(self.scopeLimit)", search: "")
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { DashboardItemViewModel(with: $0) } }
                .do(onNext: { _ in
                    self.loadingMoreRelay.accept(false)
                })
        }
        
        let coins = Driver.merge(initialCoins, nextPageCoins)
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedCoin = input.selection
            .withLatestFrom(coins) { (indexPath, coins) -> DashboardItemViewModel in
                return coins[indexPath.row]
            }
            .do(onNext: navigator.toDetail)
        
        return Output(fetching: fetching,
                      refresh: refreshRelay.asDriver(),
                      coins: coins,
                      selectedCoin: selectedCoin,
                      error: errors,
                      loadingMore: loadingMoreRelay.asDriver())
    }
}
