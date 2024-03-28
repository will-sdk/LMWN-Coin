
import RxSwift
import RxCocoa
import UseCases

final class DashboardViewModel: ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let coins: Driver<[DashboardItemViewModel]>
        let selectedCoin: Driver<Coins>
        let error: Driver<Error>
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
        let coins = input.trigger.flatMapLatest {
            return self.usecase.listOfCoins()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { DashboardItemViewModel(with: $0) } }
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedCoin = input.selection
            .withLatestFrom(coins) { (indexPath, coins) -> Coins in
                return coins[indexPath.row].coin
            }
            .do(onNext: navigator.toDetail)
        
        return Output(fetching: fetching,
                      coins: coins,
                      selectedCoin: selectedCoin,
                      error: errors)
    }
}
