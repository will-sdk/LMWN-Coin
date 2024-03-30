
import Foundation
import UseCases

final class DashboardItemViewModel   {
    let title: String
    let subtitle : String
    let change: String
    let thumbnail: URL?
    let isQuery: Bool
    
    let coin: Coins?
    init (with coin: Coins?, isQuery: Bool) {
        self.coin = coin
        self.title = coin?.name ?? "N/A"
        self.subtitle = coin?.symbol ?? "N/A"
        if let changeValue = coin?.change, let changeDouble = Double(changeValue) {
            self.change = changeDouble > 0 ? "↑ \(changeValue)" : "↓ \(changeValue)"
        } else {
            self.change = "N/A"
        }
        self.thumbnail = URL(string: coin?.iconUrl ?? "")
        self.isQuery = isQuery
    }
}
