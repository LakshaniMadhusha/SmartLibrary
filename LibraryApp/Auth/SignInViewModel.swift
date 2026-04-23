import Foundation
import SwiftData

@Observable
final class SignInViewModel {
    var email: String = "sarah@library.com"
    var password: String = "password123"
    var selectedRole: UserRole = .member

    var isSubmitting = false
    var errorMessage: String?

    @MainActor
    func submit(auth: AuthService, modelContext: ModelContext) async {
        isSubmitting = true
        defer { isSubmitting = false }
        await auth.signIn(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password.trimmingCharacters(in: .whitespacesAndNewlines),
            role: selectedRole, 
            modelContext: modelContext
        )
        errorMessage = auth.errorMessage
    }
}

