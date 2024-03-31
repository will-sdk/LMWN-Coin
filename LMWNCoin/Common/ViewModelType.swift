import UIKit

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        var alpha: CGFloat = 1.0
        if hexSanitized.count == 8 { // If the string includes alpha
            alpha = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
        }

        let red = CGFloat((rgb & 0xFF00_00) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF_00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000_FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


