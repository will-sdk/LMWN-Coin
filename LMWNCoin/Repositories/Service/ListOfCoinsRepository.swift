
import UseCases
import RxSwift

public final class ListOfCoinsRepository {
    private let repo: RepositoryFromJsonFile<Coins>
    
    init(repo: RepositoryFromJsonFile<Coins>) {
        self.repo = repo
    }
    
    public func fetchListOfCoins() -> Observable<[Coins]> {
        return repo.getListOfCoinsService()
    }
}
