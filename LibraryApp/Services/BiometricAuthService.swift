// Services/BiometricAuthService.swift
import Foundation
import LocalAuthentication
import Combine

class BiometricAuthService: ObservableObject {
    @Published var isFaceIDAvailable = false
    @Published var isTouchIDAvailable = false
    @Published var biometricType: BiometricType = .none
    @Published var isAuthenticated = false
    
    enum BiometricType {
        case faceID
        case touchID
        case none
    }
    
    enum BiometricError: Error, LocalizedError {
        case biometryNotAvailable
        case biometryNotEnrolled
        case biometryLockout
        case userCancel
        case userFallback
        case passcodeNotSet
        case unknownError(String)
        
        var errorDescription: String? {
            switch self {
            case .biometryNotAvailable:
                return "Biometric authentication is not available on this device."
            case .biometryNotEnrolled:
                return "Biometric is not enrolled. Please set up Face ID or Touch ID in Settings."
            case .biometryLockout:
                return "Biometric authentication is locked. Please try again later or use your passcode."
            case .userCancel:
                return "Authentication cancelled."
            case .userFallback:
                return "Biometric authentication failed. Please use your passcode."
            case .passcodeNotSet:
                return "Device passcode is not set. Please set a passcode in Settings."
            case .unknownError(let message):
                return "Authentication failed: \(message)"
            }
        }
    }
    
    init() {
        checkBiometricAvailability()
    }
    
    // MARK: - Check Biometric Availability
    private func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            self.biometricType = .none
            if let error = error {
                print("Biometric check error: \(error.localizedDescription)")
            }
            return
        }
        
        switch context.biometryType {
        case .faceID:
            self.isFaceIDAvailable = true
            self.biometricType = .faceID
        case .touchID:
            self.isTouchIDAvailable = true
            self.biometricType = .touchID
        case .opticID:
            self.isFaceIDAvailable = true
            self.biometricType = .faceID
        case .none:
            self.biometricType = .none
        @unknown default:
            self.biometricType = .none
        }
    }
    
    // MARK: - Authenticate with Biometric or Passcode
    func authenticate(reason: String = "Authenticate to access your library account") async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw BiometricError.biometryNotAvailable
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            
            if success {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            }
            return success
        } catch let error as LAError {
            throw handleLAError(error)
        } catch {
            throw BiometricError.unknownError(error.localizedDescription)
        }
    }
    
    // MARK: - Authenticate with Biometric or Passcode Fallback
    func authenticateWithFallback(reason: String = "Authenticate to access your library account") async throws -> Bool {
        let context = LAContext()
        
        // Allow fallback to passcode
        context.localizedFallbackTitle = "Use Passcode"
        
        var error: NSError?
        
        // Try biometric first
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            do {
                let success = try await context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                )
                if success {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                }
                return success
            } catch let laError as LAError {
                // If biometric fails with userFallback, try device owner policy (passcode)
                if laError.code == .userFallback {
                    return try await authenticateWithPasscode(reason: reason)
                }
                throw handleLAError(laError)
            }
        }
        
        // Fallback to passcode if biometric not available
        return try await authenticateWithPasscode(reason: reason)
    }
    
    // MARK: - Authenticate with Device Passcode Only
    private func authenticateWithPasscode(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            if let error = error {
                throw handleLAError(error as! LAError)
            }
            throw BiometricError.passcodeNotSet
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: reason
            )
            if success {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            }
            return success
        } catch let error as LAError {
            throw handleLAError(error)
        }
    }
    
    // MARK: - Handle LAError
    private func handleLAError(_ error: LAError) -> BiometricError {
        switch error.code {
        case .biometryNotAvailable:
            return .biometryNotAvailable
        case .biometryNotEnrolled:
            return .biometryNotEnrolled
        case .biometryLockout:
            return .biometryLockout
        case .userCancel:
            return .userCancel
        case .userFallback:
            return .userFallback
        case .passcodeNotSet:
            return .passcodeNotSet
        default:
            return .unknownError(error.localizedDescription)
        }
    }
    
    // MARK: - Reset Authentication Status
    func resetAuthentication() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
    
    // MARK: - Get Biometric Display Name
    func getBiometricDisplayName() -> String {
        switch biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .none:
            return "Biometric"
        }
    }
}
