
import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        var alpha: CGFloat = 1.0
        if hexSanitized.count == 8 {
            alpha = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
        }

        let red = CGFloat((rgb & 0xFF00_00) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF_00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000_FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UILabel {
    func setFormattedCurrency(fromString string: String, currencySymbol: String = "$", maximumFractionDigits: Int = 2) {
        guard let number = Double(string) else {
            self.text = "Invalid number format."
            return
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.maximumFractionDigits = maximumFractionDigits
        
        if let formattedString = formatter.string(from: NSNumber(value: number)) {
            self.text = formattedString
        } else {
            self.text = "Error formatting number."
        }
    }
}

extension UILabel {
    func setTrillionFormattedText(from string: String, currencySymbol: String = "$") {
        guard let number = Double(string) else {
            self.text = "Invalid number format."
            return
        }

        let trillion = 1_000_000_000_000.0
        let trillionValue = number / trillion

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol

        if let formattedString = formatter.string(from: NSNumber(value: trillionValue)) {
            self.text = formattedString + " trillion"
        } else {
            self.text = "Error formatting number."
        }
    }
}
