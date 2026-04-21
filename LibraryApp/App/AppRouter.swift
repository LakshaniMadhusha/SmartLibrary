import SwiftUI
import SwiftData

struct AppRouter: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            switch auth.state {
            case .signedOut:
                SplashView()
                    .task { auth.bootstrap(modelContext: modelContext) }
                    .overlay(alignment: .bottom) {
                        AuthEntryView()
                    }
            case .signedIn(let user):
                if auth.isAppLocked {
                    AppLockView()
                } else {
                    if user.role == .member {
                        MemberTabView(user: user)
                    } else {
                        LibrarianTabView(user: user)
                    }
                }
            }
        }
        .background(Color.pageBg.ignoresSafeArea())
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                auth.didEnterBackground()
            case .active:
                auth.willEnterForeground()
            default:
                break
            }
        }
    }
}

