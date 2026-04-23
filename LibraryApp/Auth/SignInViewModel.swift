import Foundation
import SwiftData

@Observable
final class SignInViewModel {
    var email: String = "sarah@library.com"
<<<<<<< HEAD
    var password: String = "password123"
=======
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
    var selectedRole: UserRole = .member

    var isSubmitting = false
    var errorMessage: String?

    @MainActor
    func submit(auth: AuthService, modelContext: ModelContext) async {
        isSubmitting = true
        defer { isSubmitting = false }
<<<<<<< HEAD
        await auth.signIn(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password.trimmingCharacters(in: .whitespacesAndNewlines),
            role: selectedRole, 
            modelContext: modelContext
        )
=======
        await auth.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), role: selectedRole, modelContext: modelContext)
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
        errorMessage = auth.errorMessage
    }
}

