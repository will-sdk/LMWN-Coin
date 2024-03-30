
import RxSwift
import UseCases

enum CoinsError: Error {
    case invalidData
}

public final class ListOfCoinsUseCase: UseCases.ListOfCoinsUseCase {
    
    private let service: GetCoinsAPI
    private let disposeBag = DisposeBag()
    init(service: GetCoinsAPI) {
        self.service = service
    }
    
    public func listOfCoins() -> Observable<[Coins]> {
        let fetchListOfCoins = service.fetchCoins()
            .map { result -> [Coins] in
                let coinsArray = result.data.coins.map { item in
                    Coins(symbol: item.symbol ?? "",
                          name: item.name ?? "",
                          price: item.price ?? "",
                          marketCap: item.marketCap ?? "",
                          iconUrl: item.iconUrl ?? "",
                          uuid: item.uuid ?? "",
                          rank: item.rank ?? 0,
                          sparkline: item.sparkline ?? [],
                          coinrankingUrl: item.coinrankingUrl ?? "",
                          volume24h: item.volume24h ?? "",
                          btcPrice: item.btcPrice ?? "",
                          contractAddresses: item.contractAddresses ?? [],
                          change: item.change)
                }
                return coinsArray
            }
            return fetchListOfCoins
    }
}
