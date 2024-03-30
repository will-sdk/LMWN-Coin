
import RxSwift

public protocol ListOfCoinsUseCase {
    func listOfCoins(scopeLimit: String, search: String) -> Observable<[Coins]>
}

