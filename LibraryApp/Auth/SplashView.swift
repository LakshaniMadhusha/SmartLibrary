import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 44, weight: .semibold))
                .foregroundColor(.primary)
                .padding()
                .background(Color.surfaceBg)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Text("Library Companion")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text("Member & Librarian experience")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

