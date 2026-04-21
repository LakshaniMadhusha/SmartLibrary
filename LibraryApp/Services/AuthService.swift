import Foundation
import SwiftData
import Combine

@Observable
final class AuthService {
    enum AuthState: Equatable {
        case signedOut
        case signedIn(AppUser)
    }

    private(set) var state: AuthState = .signedOut
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var isAppLocked = false
    var autoLockTimeoutSeconds: TimeInterval = 300
    private var lastBackgroundAt: Date?

    // Combine example: emit state changes for non-SwiftUI consumers
    private let stateSubject = CurrentValueSubject<AuthState, Never>(.signedOut)
    var statePublisher: AnyPublisher<AuthState, Never> { stateSubject.eraseToAnyPublisher() }

    private let biometric = BiometricAuthService()

    @MainActor
    func bootstrap(modelContext: ModelContext) {
        do {
            try MockData.seedIfNeeded(modelContext: modelContext)
        } catch {
            errorMessage = "Failed to seed data."
        }
    }

    @MainActor
    func signIn(email: String, role: UserRole, modelContext: ModelContext) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await Task.sleep(for: .milliseconds(450))
            let roleRaw = role.rawValue
            let predicate = #Predicate<AppUser> { $0.email == email && $0.roleRaw == roleRaw }
            let descriptor = FetchDescriptor<AppUser>(predicate: predicate)
            if let user = try modelContext.fetch(descriptor).first {
                state = .signedIn(user)
                stateSubject.send(state)
            } else {
                errorMessage = "No account found for that email/role."
            }
        } catch {
            errorMessage = "Sign in failed."
        }
    }

    @MainActor
    func signUp(name: String, email: String, role: UserRole, modelContext: ModelContext) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await Task.sleep(for: .milliseconds(550))
            let user = AppUser(name: name, email: email, role: role)
            modelContext.insert(user)
            try modelContext.save()
            state = .signedIn(user)
            stateSubject.send(state)
        } catch {
            errorMessage = "Sign up failed."
        }
    }

    @MainActor
    func signIn(user: AppUser) {
        state = .signedIn(user)
        stateSubject.send(state)
    }

    func signOut() {
        state = .signedOut
        isAppLocked = false
        lastBackgroundAt = nil
        stateSubject.send(state)
    }

    func didEnterBackground() {
        lastBackgroundAt = .now
    }

    func willEnterForeground() {
        guard case .signedIn(let user) = state else { return }
        guard user.isBiometricEnabled else { return }
        guard let lastBackgroundAt else { return }
        guard Date().timeIntervalSince(lastBackgroundAt) >= autoLockTimeoutSeconds else { return }
        isAppLocked = true
    }

    @MainActor
    func unlockApp() async {
        errorMessage = nil
        do {
            try await biometric.authenticate(reason: "Unlock Library Companion")
            isAppLocked = false
            lastBackgroundAt = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func setBiometricEnabled(_ enabled: Bool, for user: AppUser, modelContext: ModelContext) {
        user.isBiometricEnabled = enabled
        try? modelContext.save()
    }
}

