
import Foundation
import UseCases

final class DashboardItemViewModel   {
    let title:String
    let subtitle : String
    let coin: Coins
    init (with coin: Coins) {
        self.coin = coin
        self.title = "Bitcoin"//coin.title.uppercased()
        self.subtitle = "BTC"//coin.body
    }
}
