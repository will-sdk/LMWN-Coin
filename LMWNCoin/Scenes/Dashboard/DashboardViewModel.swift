
import RxSwift
import RxCocoa
import UseCases

final class DashboardViewModel: ViewModelType {
    
    private var scopeLimit = 10
    private let loadingMoreRelay = BehaviorRelay<Bool>(value: false)
    private let refreshRelay = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let trigger: Driver<String>
        let loadMore: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let refresh: Driver<String>
        let topthreeCoins: Driver<[DashboardItemViewModel]>
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
        
        let initialCoins = input.trigger.flatMapLatest { query in
            self.usecase.listOfCoins(scopeLimit: "20", search: query)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { DashboardItemViewModel(with: $0, isQuery: query.isEmpty) } }
        }
        
        let nextPageCoins = input.loadMore
            .withLatestFrom(input.trigger)
            .flatMapLatest { query in
                self.scopeLimit += 10
                self.loadingMoreRelay.accept(true)
                self.refreshRelay.accept(false)
                return self.usecase.listOfCoins(scopeLimit: "\(self.scopeLimit)", search: query)
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .map { $0.map { DashboardItemViewModel(with: $0, isQuery: query.isEmpty) } }
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
        
        let topThreeCoins = coins
            .map { coin -> [DashboardItemViewModel] in
                guard let isQuery = coin.first?.isQuery, isQuery else {
                    return []
                }
                
                let sortedCoin = coin.sorted { coin1, coin2 in
                    return coin1.coin?.rank ?? 0 < coin2.coin?.rank ?? 0
                }
                let topThree = Array(sortedCoin.prefix(3))
                return topThree
            }
        
        
        return Output(fetching: fetching,
                      refresh: input.trigger.asDriver(),
                      topthreeCoins: topThreeCoins,
                      coins: coins,
                      selectedCoin: selectedCoin,
                      error: errors,
                      loadingMore: loadingMoreRelay.asDriver())
    }
}
