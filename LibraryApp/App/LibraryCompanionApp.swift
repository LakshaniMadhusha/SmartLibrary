import SwiftUI
import SwiftData
<<<<<<< HEAD
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
=======
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896

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
<<<<<<< HEAD
=======
            // If container creation fails, try to delete the store and recreate
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
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

<<<<<<< HEAD
    init() {
        FirebaseApp.configure()
    }

=======
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
    var body: some Scene {
        WindowGroup {
            AppRouter()
                .environment(authService)
                .modelContainer(container)
                .preferredColorScheme(.light)
<<<<<<< HEAD
                .task {
                    // Activate Global Dual Offline-Cloud Synchronization Daemon
                    FirebaseSyncService.shared.startSyncing(context: container.mainContext)
                }
=======
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
        }
    }
}

