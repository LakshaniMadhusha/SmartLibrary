// Views/AppLockView.swift
import SwiftUI

struct AppLockView: View {
    @ObservedObject var authManager: AuthenticationManager
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isAuthenticating = false
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                
                Spacer()
                
                // Lock Icon
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.Colors.accent)
                    
                    Text("App Locked")
                        .font(AppTheme.Fonts.title1)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text("Authenticate to continue")
                        .font(AppTheme.Fonts.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
                
                // Biometric Info
                if authManager.biometricAuthService.biometricType != .none {
                    VStack(spacing: AppTheme.Spacing.sm) {
                        HStack {
                            Image(systemName: authManager.biometricAuthService.biometricType == .faceID ? "face.smiling" : "touchid")
                                .font(AppTheme.Fonts.custom(size: 20))
                                .foregroundColor(AppTheme.Colors.accent)
                            
                            Text(authManager.biometricAuthService.getBiometricDisplayName())
                                .font(AppTheme.Fonts.body)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.backgroundSecondary)
                        .cornerRadius(AppTheme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                                .stroke(AppTheme.Colors.border, lineWidth: 1)
                        )
                        
                        Text("Available: \(authManager.biometricAuthService.getBiometricDisplayName()) or Device Passcode")
                            .font(AppTheme.Fonts.caption2)
                            .foregroundColor(AppTheme.Colors.textTertiary)
                    }
                } else {
                    VStack(spacing: AppTheme.Spacing.sm) {
                        HStack {
                            Image(systemName: "lock.open.trianglebadge.exclamationmark")
                                .font(AppTheme.Fonts.custom(size: 20))
                                .foregroundColor(.orange)
                            
                            Text("Biometric Not Available")
                                .font(AppTheme.Fonts.body)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.Colors.backgroundSecondary)
                        .cornerRadius(AppTheme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                                .stroke(AppTheme.Colors.border, lineWidth: 1)
                        )
                    }
                }
                
                // Unlock Button
                PrimaryButton(
                    title: isAuthenticating ? "Authenticating..." : "Unlock with \(authManager.biometricAuthService.getBiometricDisplayName())",
                    action: {
                        Task {
                            await unlockApp()
                        }
                    },
                    isLoading: isAuthenticating
                )
                
                // Sign Out Button
                SecondaryButton(
                    title: "Sign Out",
                    action: {
                        authManager.signOut()
                    }
                )
                
                // Error Message
                if showError {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(AppTheme.Fonts.subheadline)
                                .foregroundColor(.red)
                                .lineLimit(2)
                            Spacer()
                        }
                    }
                    .padding(AppTheme.Spacing.md)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(AppTheme.Radius.md)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.xxl)
        }
    }
    
    // MARK: - Unlock App
    private func unlockApp() async {
        isAuthenticating = true
        showError = false
        
        do {
            try await authManager.authenticateForAppReEntry()
        } catch let error as BiometricAuthService.BiometricError {
            errorMessage = error.localizedDescription ?? "Authentication failed"
            showError = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isAuthenticating = false
    }
}

// MARK: - Secondary Button Component
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(AppTheme.Colors.accent)
                }
                Text(title)
                    .font(AppTheme.Fonts.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.md)
            .foregroundColor(AppTheme.Colors.accent)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(AppTheme.Colors.accent, lineWidth: 2)
            )
        }
        .disabled(isLoading)
    }
}

// Preview
#Preview {
    AppLockView(authManager: AuthenticationManager.shared)
}
