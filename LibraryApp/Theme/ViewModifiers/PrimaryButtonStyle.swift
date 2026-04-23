import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
<<<<<<< HEAD
            .background(Color.accent)
            .cornerRadius(14)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.9 : 1)
=======
            .background(Color.primary)
            .cornerRadius(14)
            .opacity(configuration.isPressed ? 0.8 : 1)
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primaryButton: PrimaryButtonStyle { PrimaryButtonStyle() }
}

