import SwiftUI
import SwiftData

@main
struct LibraryCompanionApp: App {
    private let container: ModelContainer = {
        do {
            let schema = Schema([
                AppUser.self,
                Book.self,
                Loan.self,
                Reservation.self,
                Hall.self,
                Seat.self,
                ReadingSession.self,
                Badge.self,
            ])
            return try ModelContainer(for: schema)
        } catch {
            // If container creation fails, try to delete the store and recreate
            do {
                let config = ModelConfiguration()
                let storeURL = config.url
                if FileManager.default.fileExists(atPath: storeURL.path) {
                    try FileManager.default.removeItem(at: storeURL)
                }
                return try ModelContainer(for: Schema([
                    AppUser.self,
                    Book.self,
                    Loan.self,
                    Reservation.self,
                    Hall.self,
                    Seat.self,
                    ReadingSession.self,
                    Badge.self,
                ]))
            } catch {
                fatalError("SwiftData container init failed even after deleting store: \(error)")
            }
        }
    }()

    @State private var authService = AuthService()

    var body: some Scene {
        WindowGroup {
            AppRouter()
                .environment(authService)
                .modelContainer(container)
                .preferredColorScheme(.light)
        }
    }
}

