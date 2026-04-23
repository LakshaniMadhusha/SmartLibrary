import Foundation
import SwiftData

@Observable
final class SignUpViewModel {
    var name: String = ""
    var email: String = ""
<<<<<<< HEAD
    var password: String = ""
=======
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
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
<<<<<<< HEAD
            password: password.trimmingCharacters(in: .whitespacesAndNewlines),
=======
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
            role: selectedRole,
            modelContext: modelContext
        )
        errorMessage = auth.errorMessage
    }
}

