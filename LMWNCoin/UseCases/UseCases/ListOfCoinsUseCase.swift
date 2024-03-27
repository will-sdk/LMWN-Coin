
import RxSwift

public protocol ListOfCoinsUseCase {
    func listOfCoins() -> Observable<[Coins]>
}

