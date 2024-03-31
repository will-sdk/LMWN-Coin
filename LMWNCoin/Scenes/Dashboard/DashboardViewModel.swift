
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
        let topthreeCoins: Driver<[DashboardItemModel]>
        let coins: Driver<[DashboardItemModel]>
        let selectedCoin: Driver<(DashboardItemModel, Bool)>
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
                .map { $0.map { DashboardItemModel(with: $0, isQuery: query.isEmpty) } }
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
                    .map { $0.map { DashboardItemModel(with: $0, isQuery: query.isEmpty) } }
                    .do(onNext: { _ in
                        self.loadingMoreRelay.accept(false)
                    })
            }
        
        let coins = Driver.merge(initialCoins, nextPageCoins)
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let inviteFriendIndices = Set([5, 10, 20, 40, 80, 160])
        let selectedCoin = input.selection
            .withLatestFrom(coins) { (indexPath, coins) -> (DashboardItemModel, Bool) in
                let index = indexPath.row
                switch index {
                case 0...3:
                    return (coins[index], false)
                case 5...9:
                    return (coins[index - 1], false)
                case 11...20:
                    return (coins[index - 2], false)
                case 22...41:
                    return (coins[index - 3], false)
                case 43...83:
                    return (coins[index - 4], false)
                case 85...159:
                    return (coins[index - 5], false)
                default:
                    return (coins[1], true)
                }
            }
            .do { model, invite in
                if invite {
                    self.navigator.toInvitefriend()
                } else {
                    self.navigator.toDetail(model)
                }
            }
        
        let topThreeCoins = coins
            .map { coin -> [DashboardItemModel] in
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
