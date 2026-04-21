import SwiftUI

extension Color {
    static let pageBg        = Color(hex: "F7F5FF")  // soft lavender-white
    static let cardBg        = Color(hex: "FFFFFF")
    static let surfaceBg     = Color(hex: "EEF0FB")  // chip and input fills
    static let primary       = Color(hex: "6C63FF")  // purple — CTAs, active state
    static let coral         = Color(hex: "FF6584")  // error, overdue, highlights
    static let teal          = Color(hex: "2DBD9B")  // success, available
    static let amber         = Color(hex: "FFB347")  // warning, reserved
    static let textPrimary   = Color(hex: "1A1A2E")
    static let textSecondary = Color(hex: "6B6B8A")
    static let divider       = Color(hex: "E4E2F5")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

