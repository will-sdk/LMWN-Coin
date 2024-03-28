
import Foundation
import UseCases

final class RepositoryProvider {
    private let apiGetCoinsEndpoint: String
    
    public init() {
        self.apiGetCoinsEndpoint = "https://api.coinranking.com/v2/coins"
    }
    
    public func makeListOfCoinsRepository() -> GetCoinsAPI {
        let serviceAPI = ServiceAPI<CoinsResult>(apiGetCoinsEndpoint)
        return GetCoinsAPI(serviceAPI: serviceAPI)
    }
}
