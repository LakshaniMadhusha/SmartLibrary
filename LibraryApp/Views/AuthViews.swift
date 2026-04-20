// Views/AuthViews.swift
import SwiftUI

// MARK: - Splash Screen
struct SplashView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            VStack(spacing: AppTheme.Spacing.xl) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.accentMuted)
                        .frame(width: 100, height: 100)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)

                    Image(systemName: "books.vertical.fill")
                        .font(AppTheme.Fonts.custom(size: 44))
                        .foregroundColor(AppTheme.Colors.accent)
                }

                VStack(spacing: 8) {
                    Text("Library")
                        .font(AppTheme.Fonts.largeTitle)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Text("Companion")
                        .font(AppTheme.Fonts.title1)
                        .foregroundColor(AppTheme.Colors.accent)
                    Text("Your reading journey starts here")
                        .font(AppTheme.Fonts.subheadline)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onAppear { isAnimating = true }
    }
}

// MARK: - Sign In View
struct SignInView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    var onSignIn: () -> Void = {}
    var onGoToSignUp: () -> Void = {}

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppTheme.Spacing.xxl) {

                    // Logo
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "books.vertical.fill")
                            .font(AppTheme.Fonts.custom(size: 40))
                            .foregroundColor(AppTheme.Colors.accent)
                            .padding()
                            .background(AppTheme.Colors.accentMuted)
                            .cornerRadius(AppTheme.Radius.xl)

                        Text("Welcome Back")
                            .font(AppTheme.Fonts.title1)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Text("Sign in to your library account")
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.top, 60)

                    // Form
                    VStack(spacing: AppTheme.Spacing.md) {
                        InputField(
                            label: "Email",
                            placeholder: "your@email.com",
                            text: $email,
                            icon: "envelope"
                        )
                        InputField(
                            label: "Password",
                            placeholder: "Enter password",
                            text: $password,
                            icon: "lock",
                            isSecure: !showPassword,
                            trailingIcon: showPassword ? "eye.slash" : "eye",
                            onTrailingTap: { showPassword.toggle() }
                        )
                        HStack {
                            Spacer()
                            Button("Forgot password?") {}
                                .font(AppTheme.Fonts.subheadline)
                                .foregroundColor(AppTheme.Colors.accent)
                        }
                    }

                    // Error Message
                    if let errorMessage = errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(AppTheme.Fonts.caption1)
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(AppTheme.Radius.md)
                    }

                    // Sign In Button
                    PrimaryButton(title: "Sign In", action: {
                        Task {
                            await handleSignIn()
                        }
                    }, isLoading: isLoading)

                    // Divider
                    HStack {
                        Rectangle().fill(AppTheme.Colors.border).frame(height: 1)
                        Text("or").font(AppTheme.Fonts.caption1).foregroundColor(AppTheme.Colors.textTertiary)
                        Rectangle().fill(AppTheme.Colors.border).frame(height: 1)
                    }

                    // Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Button("Sign Up") { onGoToSignUp() }
                            .font(AppTheme.Fonts.headline)
                            .foregroundColor(AppTheme.Colors.accent)
                    }

                    Spacer(minLength: AppTheme.Spacing.xxxl)
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
    }
    
    // MARK: - Handle Sign In
    private func handleSignIn() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authManager.signIn(email: email, password: password)
            onSignIn()
        } catch {
            errorMessage = "Sign in failed. Please check your credentials."
        }
        
        isLoading = false
    }
}

// MARK: - Sign Up View
struct SignUpView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    var onSignUp: () -> Void = {}
    var onGoToSignIn: () -> Void = {}

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: AppTheme.Spacing.xl) {

                    VStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "person.badge.plus")
                            .font(AppTheme.Fonts.custom(size: 40))
                            .foregroundColor(AppTheme.Colors.accent)
                            .padding()
                            .background(AppTheme.Colors.accentMuted)
                            .cornerRadius(AppTheme.Radius.xl)

                        Text("Create Account")
                            .font(AppTheme.Fonts.title1)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Text("Join the reading community")
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.top, 40)

                    VStack(spacing: AppTheme.Spacing.md) {
                        InputField(label: "Full Name",    placeholder: "Your full name",    text: $fullName, icon: "person")
                        InputField(label: "Email",        placeholder: "your@email.com",    text: $email, icon: "envelope")
                        InputField(label: "Password",     placeholder: "Create password",   text: $password, icon: "lock", isSecure: true)
                        InputField(label: "Confirm",      placeholder: "Repeat password",   text: $confirmPassword, icon: "lock.fill", isSecure: true)
                    }

                    // Error Message
                    if let errorMessage = errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(AppTheme.Fonts.caption1)
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(AppTheme.Radius.md)
                    }

                    PrimaryButton(title: "Create Account", action: {
                        Task {
                            await handleSignUp()
                        }
                    }, isLoading: isLoading)

                    HStack {
                        Text("Already have an account?")
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Button("Sign In") { onGoToSignIn() }
                            .font(AppTheme.Fonts.headline)
                            .foregroundColor(AppTheme.Colors.accent)
                    }

                    Spacer(minLength: AppTheme.Spacing.xxxl)
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
    }
    
    // MARK: - Handle Sign Up
    private func handleSignUp() async {
        isLoading = true
        errorMessage = nil
        
        // Validate inputs
        if fullName.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields"
            isLoading = false
            return
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords don't match"
            isLoading = false
            return
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            isLoading = false
            return
        }
        
        do {
            try await authManager.signUp(name: fullName, email: email, password: password)
            onSignUp()
        } catch {
            errorMessage = "Sign up failed. Please try again."
        }
        
        isLoading = false
    }
}

// MARK: - Reusable Input Field
struct InputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var icon: String = ""
    var isSecure: Bool = false
    var trailingIcon: String? = nil
    var onTrailingTap: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(AppTheme.Fonts.caption1)
                .foregroundColor(AppTheme.Colors.textSecondary)

            HStack(spacing: AppTheme.Spacing.sm) {
                if !icon.isEmpty {
                    Image(systemName: icon)
                        .font(AppTheme.Fonts.custom(size: 16))
                        .foregroundColor(AppTheme.Colors.textTertiary)
                        .frame(width: 20)
                }
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(AppTheme.Fonts.body)
                } else {
                    TextField(placeholder, text: $text)
                        .font(AppTheme.Fonts.body)
                }
                if let trailingIcon = trailingIcon {
                    Button(action: { onTrailingTap?() }) {
                        Image(systemName: trailingIcon)
                            .font(AppTheme.Fonts.custom(size: 16))
                            .foregroundColor(AppTheme.Colors.textTertiary)
                    }
                }
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
}

