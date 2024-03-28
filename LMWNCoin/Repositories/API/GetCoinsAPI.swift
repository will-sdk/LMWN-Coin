
import Foundation
import UseCases
import RxSwift

public final class GetCoinsAPI {
    private let serviceAPI: ServiceAPI<CoinsResult>
    
    init(serviceAPI: ServiceAPI<CoinsResult>) {
        self.serviceAPI = serviceAPI
    }
    
    public func fetchCoins() -> Observable<CoinsResult> {
        return serviceAPI.getCoinsItem()
    }
}
