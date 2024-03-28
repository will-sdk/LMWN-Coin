
import Foundation
import UseCases

public final class UseCaseProvider: UseCases.UseCaseProvider {
    
    private let repositoryProvider: RepositoryProvider
    
    public init() {
        repositoryProvider = RepositoryProvider()
    }
    
    public func makeListOfCoinsUseCase() -> UseCases.ListOfCoinsUseCase {
        return ListOfCoinsUseCase(repo: repositoryProvider.makeListOfCoinsRepository())
    }
}
