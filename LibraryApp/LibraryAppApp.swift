
import SwiftUI

@main
struct LibraryAppApp: App {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
// ContentView.swift (Authentication & Tab Container)
struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showAuthFlow = false
    @State private var showSignUp = false
    @State private var showBiometricSetup = false
    
    // Controllers
    @StateObject private var homeController      = HomeController()
    @StateObject private var libraryController   = LibraryController()
    @StateObject private var seatsController     = SeatsController()
    @StateObject private var profileController   = ProfileController()
    @StateObject private var rewardsController   = RewardsController()
    @StateObject private var librarianController = LibrarianController()

    @State private var selectedTab = 0

    var body: some View {
        Group {
            // Show app lock if app is locked
            if authManager.isAppLocked {
                AppLockView(authManager: authManager)
            }
            // Show biometric setup after sign up
            else if showBiometricSetup {
                BiometricSetupView(authManager: authManager) {
                    showBiometricSetup = false
                }
            }
            // Show auth flow if not logged in
            else if !authManager.isLoggedIn {
                AuthFlowContainer(
                    showSignUp: $showSignUp,
                    authManager: authManager
                ) {
                    showBiometricSetup = true
                }
            }
            // Show main app
            else {
                ZStack(alignment: .bottom) {
                    TabView(selection: $selectedTab) {
                        HomeView(controller: homeController)
                            .tag(0)

                        LibraryView(controller: libraryController)
                            .tag(1)

                        SeatsView(controller: seatsController)
                            .tag(2)

                        RewardsView(controller: rewardsController)
                            .tag(3)

                        ProfileView(controller: profileController)
                            .tag(4)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    // Custom Tab Bar
                    CustomTabBar(selectedTab: $selectedTab)
                }
                .ignoresSafeArea(edges: .bottom)
                .preferredColorScheme(.light)
            }
        }
    }
}

// MARK: - Auth Flow Container
struct AuthFlowContainer: View {
    @Binding var showSignUp: Bool
    @ObservedObject var authManager: AuthenticationManager
    var onSignInSuccess: () -> Void
    
    var body: some View {
        if showSignUp {
            SignUpView(authManager: authManager, onSignUp: {
                showSignUp = false
                onSignInSuccess()
            }, onGoToSignIn: {
                showSignUp = false
            })
        } else {
            SignInView(authManager: authManager, onSignIn: {
                onSignInSuccess()
            }, onGoToSignUp: {
                showSignUp = true
            })
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [(icon: String, label: String)] = [
        ("house.fill",         "Home"),
        ("books.vertical.fill","Library"),
        ("chair.lounge.fill",  "Seats"),
        ("trophy.fill",        "Rewards"),
        ("person.fill",        "Profile")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                tabItem(index: index)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.sm)
        .padding(.vertical, AppTheme.Spacing.sm)
        .padding(.bottom, 20) // safe area bottom
        .background(
            AppTheme.Colors.backgroundCard
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: -4)
        )
    }

    private func tabItem(index: Int) -> some View {
        let isSelected = selectedTab == index
        return Button(action: { selectedTab = index }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                            .fill(AppTheme.Colors.accentMuted)
                            .frame(width: 44, height: 28)
                    }
                    Image(systemName: tabs[index].icon)
                        .font(AppTheme.Fonts.custom(size: 18, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? AppTheme.Colors.accent : AppTheme.Colors.textTertiary)
                }
                Text(tabs[index].label)
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(isSelected ? AppTheme.Colors.accent : AppTheme.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
    }
}
