
import Foundation

public struct Coins: Codable {
    public let symbol: String
    public let name: String
    public let price: String
    
    public init(symbol: String,
                name: String,
                price: String) {
        self.symbol = symbol
        self.name = name
        self.price = price
    }
    
    private enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case price
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(String.self, forKey: .price)
    }
}


extension Coins: Equatable {
    public static func == (lhs: Coins, rhs: Coins) -> Bool {
        return lhs.symbol == rhs.symbol &&
        lhs.name == rhs.name &&
        lhs.price == rhs.price
    }
}
