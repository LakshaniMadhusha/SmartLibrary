import SwiftUI
import SwiftData
import LocalAuthentication

struct SignInView: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.modelContext) private var modelContext

    @State private var vm = SignInViewModel()
    @State private var isBiometricAvailable = false
    var onGoToSignUp: () -> Void

    private let biometric = BiometricAuthService()

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Sign in")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                Text("Choose a role and continue")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                TextField("Email", text: $vm.email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .inputStyle()

                Picker("Role", selection: $vm.selectedRole) {
                    ForEach(UserRole.allCases, id: \.self) { role in
                        Text(role.rawValue).tag(role)
                    }
                }
                .pickerStyle(.segmented)
            }

            if isBiometricAvailable {
                Button {
                    Task { await biometricSignIn() }
                } label: {
                    HStack {
                        Image(systemName: "faceid")
                        Text("Sign in with Biometric")
                    }
                }
                .buttonStyle(.secondaryButton)
            }

            if let msg = auth.errorMessage ?? vm.errorMessage {
                Text(msg)
                    .font(.caption)
                    .foregroundColor(.coral)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                Task { await vm.submit(auth: auth, modelContext: modelContext) }
            } label: {
                if auth.isLoading || vm.isSubmitting {
                    ProgressView().tint(.white)
                } else {
                    Text("Continue")
                }
            }
            .buttonStyle(.primaryButton)

            Button("Create an account", action: onGoToSignUp)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .buttonStyle(.plain)
        }
        .padding(20)
        .lightCard()
        .padding(.horizontal, 20)
        .onAppear {
            let context = LAContext()
            var error: NSError?
            isBiometricAvailable = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        }
    }

    @MainActor
    private func biometricSignIn() async {
        do {
            try await biometric.authenticate(reason: "Sign in to Library Companion")
            // Find user with biometric enabled
            let predicate = #Predicate<AppUser> { $0.isBiometricEnabled }
            let descriptor = FetchDescriptor<AppUser>(predicate: predicate)
            if let user = try modelContext.fetch(descriptor).first {
                auth.signIn(user: user)
            } else {
                vm.errorMessage = "No user with biometric authentication enabled found."
            }
        } catch {
            vm.errorMessage = error.localizedDescription
        }
    }
}

