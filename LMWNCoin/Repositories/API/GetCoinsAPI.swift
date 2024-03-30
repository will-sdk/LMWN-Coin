
import Foundation
import UseCases
import RxSwift

public final class GetCoinsAPI {
    private let serviceAPI: ServiceAPI<CoinsResult>
    
    init(serviceAPI: ServiceAPI<CoinsResult>) {
        self.serviceAPI = serviceAPI
    }
    
    public func fetchCoins(scopeLimit: String, search: String) -> Observable<CoinsResult> {
        return serviceAPI.getCoinsItem(scopeLimit: scopeLimit, search: search)
    }
}
