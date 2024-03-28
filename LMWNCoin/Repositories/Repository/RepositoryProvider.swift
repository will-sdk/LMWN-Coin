
import Foundation
import UseCases

final class RepositoryProvider {
    private let jsonFileName: String
    private let typeFileName: String
    
    public init() {
        self.jsonFileName = "coins"
        self.typeFileName = "json"
    }
    
    public func makeListOfCoinsRepository() -> ListOfCoinsRepository {
        let repo = RepositoryFromJsonFile<Coins>(jsonFileName: jsonFileName, typeFileNam: typeFileName)
        return ListOfCoinsRepository(repo: repo)
    }
}
