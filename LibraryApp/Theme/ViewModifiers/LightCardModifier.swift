import SwiftUI

struct LightCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBg)
            .cornerRadius(18)
<<<<<<< HEAD
            .shadow(color: Color.black.opacity(0.2), radius: 12, y: 4)
=======
            .shadow(color: Color.primary.opacity(0.08), radius: 12, y: 4)
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
    }
}

extension View {
    func lightCard() -> some View {
        modifier(LightCardModifier())
    }
}

