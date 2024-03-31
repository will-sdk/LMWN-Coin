
import Foundation

public struct CoinsResult: Codable {
    public let data: CoinsData
}

public struct CoinsData: Codable {
    public let coins: [Coins]
}

public struct Coins: Codable {
    public let symbol: String?
    public let name: String?
    public let price: String?
    public let marketCap: String?
    public let iconUrl: String?
    public let uuid: String?
    public let rank: Int?
    public let sparkline: [String?]?
    public let coinrankingUrl: String?
    public let volume24h: String?
    public let btcPrice: String?
    public let contractAddresses: [String?]?
    public let change: String?
    
    public init(symbol: String?,
                name: String?,
                price: String?,
                marketCap: String?,
                iconUrl: String?,
                uuid: String?,
                rank: Int?,
                sparkline: [String?]?,
                coinrankingUrl: String?,
                volume24h: String?,
                btcPrice: String?,
                contractAddresses: [String?]?,
                change: String?) {
        self.symbol = symbol
        self.name = name
        self.price = price
        self.marketCap = marketCap
        self.iconUrl = iconUrl
        self.uuid = uuid
        self.rank = rank
        self.sparkline = sparkline
        self.coinrankingUrl = coinrankingUrl
        self.volume24h = volume24h
        self.btcPrice = btcPrice
        self.contractAddresses = contractAddresses
        self.change = change
    }

    private enum CodingKeys: String, CodingKey {
        case symbol, name, price, marketCap, iconUrl, uuid, rank, sparkline, coinrankingUrl
        case volume24h = "24hVolume"
        case btcPrice
        case contractAddresses
        case change
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(String.self, forKey: .price)
        marketCap = try container.decode(String.self, forKey: .marketCap)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        uuid = try container.decode(String.self, forKey: .uuid)
        rank = try container.decode(Int.self, forKey: .rank)
        sparkline = try container.decode([String?].self, forKey: .sparkline).map { $0 ?? "" }
        coinrankingUrl = try container.decode(String.self, forKey: .coinrankingUrl)
        volume24h = try container.decode(String.self, forKey: .volume24h)
        btcPrice = try container.decode(String.self, forKey: .btcPrice)
        contractAddresses = try container.decode([String?].self, forKey: .contractAddresses)
        change = try container.decodeIfPresent(String.self, forKey: .change)
    }
}


