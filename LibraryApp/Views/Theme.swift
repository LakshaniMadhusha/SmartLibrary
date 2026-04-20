// Views/Theme.swift
import SwiftUI

// MARK: - Light Color Theme
struct AppTheme {

    // MARK: - Primary Colors
    struct Colors {
        // Background hierarchy
        static let background          = Color(hex: "#F5F4F0")   // Warm off-white
        static let backgroundSecondary = Color(hex: "#EDECEA")   // Slightly deeper warm
        static let backgroundCard      = Color(hex: "#FFFFFF")   // Pure white cards
        static let backgroundElevated  = Color(hex: "#FAFAF8")   // Subtle elevated

        // Brand / Accent
        static let accent        = Color(hex: "#2D6A4F")  // Deep library green
        static let accentLight   = Color(hex: "#52B788")  // Lighter green
        static let accentMuted   = Color(hex: "#D8F3DC")  // Very light green tint
        static let accentWarm    = Color(hex: "#B7763E")  // Warm amber/gold accent

        // Status
        static let available  = Color(hex: "#40916C")  // Green
        static let borrowed   = Color(hex: "#E76F51")  // Coral/orange
        static let reserved   = Color(hex: "#457B9D")  // Steel blue
        static let overdue    = Color(hex: "#C1121F")  // Red

        // Text hierarchy
        static let textPrimary   = Color(hex: "#1A1A1A")  // Near-black
        static let textSecondary = Color(hex: "#5C5C5C")  // Medium gray
        static let textTertiary  = Color(hex: "#9A9A9A")  // Light gray
        static let textOnAccent  = Color(hex: "#FFFFFF")  // White on green

        // UI Elements
        static let border        = Color(hex: "#E0DDD8")
        static let divider       = Color(hex: "#EBEBEB")
        static let shadow        = Color(hex: "#000000").opacity(0.06)
        static let shimmer       = Color(hex: "#F0EDE8")

        // Seat map
        static let seatAvailable = Color(hex: "#B7E4C7")
        static let seatOccupied  = Color(hex: "#FFCDB2")
        static let seatReserved  = Color(hex: "#BDE0FE")
        static let seatSelected  = Color(hex: "#2D6A4F")
    }

    // MARK: - Typography
    struct Fonts {
        static func custom(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            Font.system(size: size, weight: weight, design: .default)
        }

        static let largeTitle   = custom(size: 34, weight: .bold)
        static let title1       = custom(size: 28, weight: .semibold)
        static let title2       = custom(size: 22, weight: .semibold)
        static let title3       = custom(size: 20, weight: .medium)
        static let headline     = custom(size: 17, weight: .semibold)
        static let body         = custom(size: 17, weight: .regular)
        static let callout      = custom(size: 16, weight: .regular)
        static let subheadline  = custom(size: 15, weight: .medium)
        static let footnote     = custom(size: 13, weight: .regular)
        static let caption1     = custom(size: 12, weight: .medium)
        static let caption2     = custom(size: 11, weight: .regular)
    }

    // MARK: - Spacing
    struct Spacing {
        static let xs:   CGFloat = 4
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 12
        static let base: CGFloat = 16
        static let lg:   CGFloat = 20
        static let xl:   CGFloat = 24
        static let xxl:  CGFloat = 32
        static let xxxl: CGFloat = 48
    }

    // MARK: - Corner Radius
    struct Radius {
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 12
        static let lg:   CGFloat = 16
        static let xl:   CGFloat = 20
        static let pill: CGFloat = 999
    }

    // MARK: - Shadows
    struct Shadows {
        static func card() -> some View {
            EmptyView()
        }

        static let cardShadow = Shadow(color: Color.black.opacity(0.07), radius: 12, x: 0, y: 4)
        static let elevatedShadow = Shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
    }

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Colors.backgroundCard)
            .cornerRadius(AppTheme.Radius.lg)
            .shadow(
                color: AppTheme.Colors.shadow,
                radius: 12,
                x: 0,
                y: 4
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}

