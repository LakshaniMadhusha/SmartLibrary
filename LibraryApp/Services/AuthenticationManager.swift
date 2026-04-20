// Services/AuthenticationManager.swift
import Foundation
import Combine
import UIKit

class AuthenticationManager: NSObject, ObservableObject {
    @Published var isLoggedIn = false
    @Published var isAppLocked = false
    @Published var biometricAuthService = BiometricAuthService()
    @Published var currentUser: User? = nil
    @Published var isBiometricEnabled = false
    @Published var autoLockTimeout: TimeInterval = 300 // 5 minutes
    
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var lockTimer: Timer?
    
    static let shared = AuthenticationManager()
    
    override init() {
        super.init()
        setupAppLifecycleMonitoring()
        loadAuthenticationState()
    }
    
    // MARK: - Setup App Lifecycle Monitoring
    private func setupAppLifecycleMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    // MARK: - App Lifecycle Methods
    @objc private func appDidEnterBackground() {
        // Lock app after timeout
        startAutoLockTimer()
    }
    
    @objc private func appWillEnterForeground() {
        stopAutoLockTimer()
        if isLoggedIn && shouldLockApp() {
            isAppLocked = true
        }
    }
    
    // MARK: - Auto Lock Timer
    private func startAutoLockTimer() {
        lockTimer = Timer.scheduledTimer(withTimeInterval: autoLockTimeout, repeats: false) { [weak self] _ in
            self?.isAppLocked = true
        }
    }
    
    private func stopAutoLockTimer() {
        lockTimer?.invalidate()
        lockTimer = nil
    }
    
    // MARK: - Sign In with Email/Password
    func signIn(email: String, password: String) async throws {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Create mock user
        let mockUser = User(
            name: "John Doe",
            email: email,
            profileImageName: "profile_john",
            memberSince: Date()
        )
        
        DispatchQueue.main.async {
            self.currentUser = mockUser
            self.isLoggedIn = true
            self.isAppLocked = false
            self.stopAutoLockTimer()
            self.saveAuthenticationState()
        }
    }
    
    // MARK: - Sign Up with Email/Password/Name
    func signUp(name: String, email: String, password: String) async throws {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        let mockUser = User(
            name: name,
            email: email,
            profileImageName: "profile_default"
        )
        
        DispatchQueue.main.async {
            self.currentUser = mockUser
            self.isLoggedIn = true
            self.isAppLocked = false
            self.stopAutoLockTimer()
            self.saveAuthenticationState()
        }
    }
    
    // MARK: - Biometric Authentication for Re-entry
    func authenticateForAppReEntry() async throws {
        guard isLoggedIn else {
            throw BiometricAuthService.BiometricError.unknownError("User not logged in")
        }
        
        let reason = "Unlock your library account"
        let _ = try await biometricAuthService.authenticateWithFallback(reason: reason)
        
        DispatchQueue.main.async {
            self.isAppLocked = false
            self.stopAutoLockTimer()
        }
    }
    
    // MARK: - Biometric Authentication for Sensitive Operations
    func authenticateForSensitiveOperation(_ operationName: String) async throws {
        let reason = "Confirm \(operationName) with Face ID or Touch ID"
        let _ = try await biometricAuthService.authenticateWithFallback(reason: reason)
    }
    
    // MARK: - Enable/Disable Biometric
    func enableBiometric(_ enable: Bool) {
        DispatchQueue.main.async {
            self.isBiometricEnabled = enable
            self.saveAuthenticationState()
        }
    }
    
    // MARK: - Set Auto Lock Timeout
    func setAutoLockTimeout(_ seconds: TimeInterval) {
        autoLockTimeout = seconds
        saveAuthenticationState()
    }
    
    // MARK: - Sign Out
    func signOut() {
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isLoggedIn = false
            self.isAppLocked = false
            self.stopAutoLockTimer()
            self.biometricAuthService.resetAuthentication()
            self.deleteAuthenticationState()
        }
    }
    
    // MARK: - Check if App Should Lock
    private func shouldLockApp() -> Bool {
        return isLoggedIn && isBiometricEnabled
    }
    
    // MARK: - Persistence
    private func saveAuthenticationState() {
        if let user = currentUser,
           let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
            UserDefaults.standard.set(isBiometricEnabled, forKey: "biometricEnabled")
            UserDefaults.standard.set(autoLockTimeout, forKey: "autoLockTimeout")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    private func loadAuthenticationState() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            DispatchQueue.main.async {
                self.currentUser = user
                self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                self.isBiometricEnabled = UserDefaults.standard.bool(forKey: "biometricEnabled")
                let timeout = UserDefaults.standard.double(forKey: "autoLockTimeout")
                if timeout > 0 {
                    self.autoLockTimeout = timeout
                }
            }
        }
    }
    
    private func deleteAuthenticationState() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "biometricEnabled")
        UserDefaults.standard.removeObject(forKey: "autoLockTimeout")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        stopAutoLockTimer()
    }
}
