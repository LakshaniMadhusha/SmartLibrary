import SwiftUI

struct ProfileView: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.modelContext) private var modelContext
    let user: AppUser
    @State private var biometricToggle: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    VStack(spacing: 10) {
                        Circle()
                            .fill(Color.surfaceBg)
                            .frame(width: 78, height: 78)
                            .overlay(
                                Text(user.name.prefix(1))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            )

                        Text(user.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)

                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    .lightCard()

                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("Require authentication on re-entry", isOn: $biometricToggle)
                            .tint(.primary)
                            .onChange(of: biometricToggle) { _, newValue in
                                auth.setBiometricEnabled(newValue, for: user, modelContext: modelContext)
                            }

                        Text("Uses Face ID / Touch ID with passcode fallback.")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .lightCard()

                    Button("Sign out") { auth.signOut() }
                        .buttonStyle(.secondaryButton)
                }
                .padding(20)
            }
            .background(Color.pageBg.ignoresSafeArea())
            .navigationTitle("Profile")
        }
        .onAppear { biometricToggle = user.isBiometricEnabled }
    }
}

