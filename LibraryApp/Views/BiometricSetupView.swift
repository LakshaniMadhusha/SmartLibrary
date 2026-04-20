// Views/BiometricSetupView.swift
import SwiftUI

struct BiometricSetupView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var showSkip = false
    var onComplete: () -> Void = {}
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                
                Spacer()
                
                // Icon
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: authManager.biometricAuthService.biometricType == .faceID ? "face.smiling" : "touchid")
                        .font(.system(size: 70))
                        .foregroundColor(AppTheme.Colors.accent)
                    
                    Text("Secure Your Account")
                        .font(AppTheme.Fonts.title1)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text("Use \(authManager.biometricAuthService.getBiometricDisplayName()) to quickly and securely unlock your account")
                        .font(AppTheme.Fonts.body)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Features
                VStack(spacing: AppTheme.Spacing.lg) {
                    FeatureRow(
                        icon: "lock.shield.fill",
                        title: "Enhanced Security",
                        subtitle: "Your biometric data never leaves your device"
                    )
                    
                    FeatureRow(
                        icon: "lightning.fill",
                        title: "Quick Access",
                        subtitle: "Unlock with a single touch or glance"
                    )
                    
                    FeatureRow(
                        icon: "checkmark.shield.fill",
                        title: "Confirm Transactions",
                        subtitle: "Verify sensitive actions with biometric"
                    )
                }
                
                Spacer()
                
                // Buttons
                VStack(spacing: AppTheme.Spacing.md) {
                    PrimaryButton(
                        title: "Enable \(authManager.biometricAuthService.getBiometricDisplayName())",
                        action: {
                            authManager.enableBiometric(true)
                            onComplete()
                        }
                    )
                    
                    SecondaryButton(
                        title: "Skip for Now",
                        action: {
                            authManager.enableBiometric(false)
                            onComplete()
                        }
                    )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.xxl)
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(AppTheme.Fonts.custom(size: 24))
                .foregroundColor(AppTheme.Colors.accent)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text(subtitle)
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.md)
    }
}

#Preview {
    BiometricSetupView(authManager: AuthenticationManager.shared)
}
