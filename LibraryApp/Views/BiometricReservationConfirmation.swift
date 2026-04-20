// Views/BiometricReservationConfirmation.swift
import SwiftUI

struct BiometricReservationConfirmation: View {
    @Binding var isPresented: Bool
    let seatNumber: String
    @ObservedObject var authManager: AuthenticationManager
    @Binding var isAuthenticating: Bool
    @Binding var authError: String?
    var onConfirm: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                
                VStack(spacing: AppTheme.Spacing.xl) {
                    
                    // Header
                    HStack {
                        Text("Confirm Reservation")
                            .font(AppTheme.Fonts.title2)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Spacer()
                        Button(action: { isPresented = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppTheme.Colors.textTertiary)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.top, AppTheme.Spacing.lg)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: AppTheme.Spacing.xl) {
                            
                            // Seat Info
                            VStack(spacing: AppTheme.Spacing.md) {
                                HStack {
                                    Image(systemName: "chair")
                                        .font(AppTheme.Fonts.custom(size: 28))
                                        .foregroundColor(AppTheme.Colors.accent)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Seat Number")
                                            .font(AppTheme.Fonts.caption1)
                                            .foregroundColor(AppTheme.Colors.textSecondary)
                                        Text(seatNumber)
                                            .font(AppTheme.Fonts.title2)
                                            .foregroundColor(AppTheme.Colors.textPrimary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(AppTheme.Spacing.md)
                                .background(AppTheme.Colors.backgroundSecondary)
                                .cornerRadius(AppTheme.Radius.md)
                            }
                            
                            // Reservation Details
                            VStack(spacing: AppTheme.Spacing.sm) {
                                reservationDetailRow(
                                    icon: "clock.fill",
                                    label: "Duration",
                                    value: "2 hours"
                                )
                                
                                reservationDetailRow(
                                    icon: "calendar",
                                    label: "Reservation Time",
                                    value: getCurrentTime()
                                )
                                
                                reservationDetailRow(
                                    icon: "exclamationmark.circle.fill",
                                    label: "Important",
                                    value: "Extend or cancel 30 mins before expiry"
                                )
                            }
                            
                            // Security Notice
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                HStack {
                                    Image(systemName: "lock.shield")
                                        .foregroundColor(AppTheme.Colors.accent)
                                    Text("Biometric Protected")
                                        .font(AppTheme.Fonts.caption1)
                                        .foregroundColor(AppTheme.Colors.accent)
                                }
                                
                                Text("Your reservation will be confirmed using your biometric authentication for maximum security.")
                                    .font(AppTheme.Fonts.caption1)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            .padding(AppTheme.Spacing.md)
                            .background(AppTheme.Colors.accentMuted)
                            .cornerRadius(AppTheme.Radius.md)
                            
                            // Error Message
                            if let error = authError {
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text(error)
                                        .font(AppTheme.Fonts.caption1)
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                                .padding(AppTheme.Spacing.md)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(AppTheme.Radius.md)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, AppTheme.Spacing.xl)
                    }
                    
                    // Action Buttons
                    VStack(spacing: AppTheme.Spacing.md) {
                        PrimaryButton(
                            title: isAuthenticating ? "Authenticating..." : "Confirm with \(authManager.biometricAuthService.getBiometricDisplayName())",
                            action: {
                                Task {
                                    await confirmReservation()
                                }
                            },
                            isLoading: isAuthenticating
                        )
                        
                        SecondaryButton(
                            title: "Cancel",
                            action: { isPresented = false }
                        )
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.bottom, AppTheme.Spacing.xl)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Confirm Reservation
    private func confirmReservation() async {
        isAuthenticating = true
        authError = nil
        
        do {
            try await authManager.authenticateForSensitiveOperation("seat reservation")
            onConfirm()
            isPresented = false
        } catch let error as BiometricAuthService.BiometricError {
            authError = error.localizedDescription ?? "Authentication failed"
        } catch {
            authError = error.localizedDescription
        }
        
        isAuthenticating = false
    }
    
    // MARK: - Helper Methods
    private func reservationDetailRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(AppTheme.Fonts.custom(size: 14))
                .foregroundColor(AppTheme.Colors.accent)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text(value)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.md)
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

#Preview {
    BiometricReservationConfirmation(
        isPresented: .constant(true),
        seatNumber: "A-5",
        authManager: AuthenticationManager.shared,
        isAuthenticating: .constant(false),
        authError: .constant(nil),
        onConfirm: {}
    )
}
