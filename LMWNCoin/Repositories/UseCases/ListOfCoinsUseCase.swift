
import RxSwift
import UseCases

public final class ListOfCoinsUseCase: UseCases.ListOfCoinsUseCase {
    
    private let repo: ListOfCoinsRepository
    
    init(repo: ListOfCoinsRepository) {
        self.repo = repo
    }
    
    public func listOfCoins() -> Observable<[Coins]> {
        let fetchListOfCoins = repo.fetchListOfCoins()
        return fetchListOfCoins
    }
}
