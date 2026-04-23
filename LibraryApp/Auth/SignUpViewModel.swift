import Foundation
import SwiftData

@Observable
final class SignUpViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var selectedRole: UserRole = .member

    var isSubmitting = false
    var errorMessage: String?

    @MainActor
    func submit(auth: AuthService, modelContext: ModelContext) async {
        isSubmitting = true
        defer { isSubmitting = false }
        await auth.signUp(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password.trimmingCharacters(in: .whitespacesAndNewlines),
            role: selectedRole,
            modelContext: modelContext
        )
        errorMessage = auth.errorMessage
    }
}

