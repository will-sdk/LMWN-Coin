
import Foundation
import UseCases

struct TopThreeItemModel {
    let title: String
    let subtitle : String
    let change: String
    let thumbnail: URL?
    let isUpScale : Bool
    
    let coin: Coins?
    init (with coin: Coins?) {
        self.coin = coin
        self.title = coin?.name ?? "N/A"
        self.subtitle = coin?.symbol ?? "N/A"
        if let changeValue = coin?.change, let changeDouble = Double(changeValue) {
            self.change = changeDouble > 0 ? "↑ \(changeValue)" : "↓ \(changeValue)"
            self.isUpScale = changeDouble > 0 ? true : false
        } else {
            self.change = "N/A"
            self.isUpScale = false
        }
        self.thumbnail = URL(string: coin?.iconUrl ?? "")
    }
}
