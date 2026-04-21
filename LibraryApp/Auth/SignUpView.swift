import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.modelContext) private var modelContext

    @State private var vm = SignUpViewModel()
    var onGoToSignIn: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Create account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                Text("Use a light theme and SwiftData-backed profile")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                TextField("Name", text: $vm.name)
                    .inputStyle()
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
                    Text("Create account")
                }
            }
            .buttonStyle(.primaryButton)

            Button("I already have an account", action: onGoToSignIn)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .buttonStyle(.plain)
        }
        .padding(20)
        .lightCard()
        .padding(.horizontal, 20)
    }
}

