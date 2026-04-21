import SwiftUI

struct LightCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBg)
            .cornerRadius(18)
            .shadow(color: Color.primary.opacity(0.08), radius: 12, y: 4)
    }
}

extension View {
    func lightCard() -> some View {
        modifier(LightCardModifier())
    }
}

