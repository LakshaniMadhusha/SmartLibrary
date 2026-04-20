// Controllers/HomeController.swift
import Foundation
import Combine
import SwiftUI

class HomeController: ObservableObject {
    @Published var currentUser: User? = User.sampleUser
    @Published var currentlyReading: [Book] = []
    @Published var newArrivals: [Book] = []
    @Published var topPicks: [Book] = []
    @Published var activeLoans: [LoanInfo] = []
    @Published var activeReservations: [ReservationInfo] = []
    @Published var alerts: [DashboardAlert] = []
    @Published var isLoading: Bool = false

    init() {
        loadData()
    }

    private func loadData() {
        let allBooks = Book.sampleBooks
        currentlyReading = allBooks.filter { $0.isBorrowed && $0.currentPage > 0 }
        newArrivals = allBooks.filter { $0.isAvailable }
        topPicks = allBooks.filter { $0.rating >= 4.0 }
        
        // Generate active loans (borrowed books with due dates)
        activeLoans = allBooks.filter { $0.isBorrowed }.map { book in
            LoanInfo(
                book: book,
                borrowedDate: book.borrowedDate ?? Date(timeIntervalSinceNow: -7*86400),
                dueDate: book.dueDate ?? Date(timeIntervalSinceNow: 7*86400),
                renewalCount: Int.random(in: 0...2)
            )
        }
        
        // Generate active reservations
        activeReservations = allBooks.filter { $0.isReserved }.map { book in
            let reservedDaysAgo = Int.random(in: 1...4)
            let reservedDate = Calendar.current.date(byAdding: .day, value: -reservedDaysAgo, to: Date()) ?? Date()
            let reservedUntil = Calendar.current.date(byAdding: .day, value: Int.random(in: 2...6), to: Date())

            return ReservationInfo(
                book: book,
                reservedDate: reservedDate,
                reservedUntil: reservedUntil,
                position: Int.random(in: 1...5)
            )
        }
        
        // Generate alerts
        generateAlerts()
    }
    
    private func generateAlerts() {
        alerts = []
        
        // Overdue alerts
        for loan in activeLoans {
            if loan.dueDate < Date() {
                let daysOverdue = Int(Date().timeIntervalSince(loan.dueDate) / 86400)
                alerts.append(
                    DashboardAlert(
                        type: .overdue,
                        title: "Overdue: \(loan.book.title)",
                        message: "\(daysOverdue) day\(daysOverdue == 1 ? "" : "s") overdue",
                        book: loan.book,
                        urgency: .high
                    )
                )
            } else if loan.dueDate.timeIntervalSince(Date()) < 2*86400 {
                // Due soon alert
                let daysDue = Int(loan.dueDate.timeIntervalSince(Date()) / 86400) + 1
                alerts.append(
                    DashboardAlert(
                        type: .dueSoon,
                        title: "Due Soon: \(loan.book.title)",
                        message: "Due in \(daysDue) day\(daysDue == 1 ? "" : "s")",
                        book: loan.book,
                        urgency: .medium
                    )
                )
            }
        }
        
        // Pickup alerts
        if Int.random(in: 0...10) > 6 {
            let readyUntil = Calendar.current.date(byAdding: .hour, value: 4, to: Date()) ?? Date()
            alerts.append(
                DashboardAlert(
                    type: .pickupReady,
                    title: "Ready for Pickup",
                    message: "Your hold is available until \(formattedTime(readyUntil))",
                    book: nil,
                    urgency: .high
                )
            )
        }
    }

    func refreshData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadData()
            self.isLoading = false
        }
    }
    
    func renewBook(_ loan: LoanInfo) {
        if let index = activeLoans.firstIndex(where: { $0.id == loan.id }) {
            activeLoans[index].renewalCount += 1
            activeLoans[index].dueDate = Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date()
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Data Models
struct LoanInfo: Identifiable {
    let id = UUID()
    let book: Book
    var borrowedDate: Date
    var dueDate: Date
    var renewalCount: Int
    
    var daysRemaining: Int {
        Int(dueDate.timeIntervalSince(Date()) / 86400)
    }
    
    var isOverdue: Bool {
        daysRemaining < 0
    }
    
    var isDueSoon: Bool {
        daysRemaining >= 0 && daysRemaining <= 2
    }
}

struct ReservationInfo: Identifiable {
    let id = UUID()
    let book: Book
    let reservedDate: Date
    let reservedUntil: Date?
    let position: Int
    
    var daysSinceReserved: Int {
        Int(Date().timeIntervalSince(reservedDate) / 86400)
    }
    
    var reservedAgoText: String {
        if daysSinceReserved == 0 {
            return "Reserved today"
        }
        return "Reserved \(daysSinceReserved)d ago"
    }
    
    var pickupByText: String {
        guard let reservedUntil else {
            return "Reservation active"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Pick up by \(formatter.string(from: reservedUntil))"
    }
}

struct DashboardAlert: Identifiable {
    let id = UUID()
    enum AlertType {
        case overdue
        case dueSoon
        case pickupReady
    }
    
    enum Urgency {
        case low
        case medium
        case high
    }
    
    let type: AlertType
    let title: String
    let message: String
    let book: Book?
    let urgency: Urgency
    
    var color: Color {
        switch (type, urgency) {
        case (.overdue, _), (_, .high):
            return Color.red
        case (.dueSoon, _), (_, .medium):
            return Color.orange
        case (.pickupReady, _), (_, .low):
            return AppTheme.Colors.accent
        }
    }
    
    var icon: String {
        switch type {
        case .overdue:
            return "exclamationmark.circle.fill"
        case .dueSoon:
            return "calendar.badge.clock"
        case .pickupReady:
            return "package.fill"
        }
    }
}

// Controllers/LibraryController.swift
class LibraryController: ObservableObject {
    @Published var books: [Book] = Book.sampleBooks
    @Published var isGridView: Bool = false
    @Published var isLoading: Bool = false
    @Published var bookmarkedBookIds: Set<UUID> = []

    func toggleViewMode() {
        isGridView.toggle()
    }

    func toggleBookmark(_ book: Book) {
        if bookmarkedBookIds.contains(book.id) {
            bookmarkedBookIds.remove(book.id)
        } else {
            bookmarkedBookIds.insert(book.id)
        }
    }

    func isBookmarked(_ book: Book) -> Bool {
        bookmarkedBookIds.contains(book.id)
    }

    func borrowBook(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index].isBorrowed = true
        books[index].isAvailable = false
        books[index].borrowedDate = Date()
        books[index].dueDate = Calendar.current.date(byAdding: .day, value: 14, to: Date())
    }

    func returnBook(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index].isBorrowed = false
        books[index].isAvailable = true
        books[index].dueDate = nil
        books[index].borrowedDate = nil
    }

    func reserveBook(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
        books[index].isReserved = true
    }
}

// Controllers/SeatsController.swift
class SeatsController: ObservableObject {
    @Published var halls: [LibraryHall] = LibraryHall.sampleHalls
    @Published var selectedHall: LibraryHall?
    @Published var reservationMessage: String? = nil

    init() {
        selectedHall = halls.first
    }

    func selectHall(_ hall: LibraryHall) {
        selectedHall = hall
    }

    func reserveSeat(_ seat: LibraryHall.Seat) {
        guard let hallIndex = halls.firstIndex(where: { $0.id == selectedHall?.id }),
              let seatIndex = halls[hallIndex].seats.firstIndex(where: { $0.id == seat.id })
        else { return }

        halls[hallIndex].seats[seatIndex].status = .reserved
        halls[hallIndex].seats[seatIndex].reservedUntil = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
        halls[hallIndex].availableSeats = max(0, halls[hallIndex].availableSeats - 1)
        selectedHall = halls[hallIndex]
        reservationMessage = "Seat \(seat.seatNumber) reserved until \(formattedTime(halls[hallIndex].seats[seatIndex].reservedUntil!))"
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Controllers/ProfileController.swift
class ProfileController: ObservableObject {
    @Published var user: User? = User.sampleUser
    @Published var borrowedBooks: [Book] = []
    @Published var recommendedBooks: [Book] = []
    @Published var reservedBooks: [Book] = []

    init() {
        loadUserBooks()
    }

    private func loadUserBooks() {
        let all = Book.sampleBooks
        borrowedBooks    = all.filter { $0.isBorrowed }
        recommendedBooks = all.filter { $0.isRecommended }
        reservedBooks    = all.filter { $0.isReserved }
    }

    func updateReadingProgress(book: Book, page: Int) {
        // Update reading progress locally; sync to backend as needed
    }
}

// Controllers/RewardsController.swift
class RewardsController: ObservableObject {
    @Published var totalPoints: Int = 2456
    @Published var leaderboard: [LeaderboardEntry] = LeaderboardEntry.samples

    struct LeaderboardEntry: Identifiable {
        let id = UUID()
        let name: String
        let points: Int
        let booksRead: Int

        static let samples: [LeaderboardEntry] = [
            LeaderboardEntry(name: "Sarah Evans",  points: 2456, booksRead: 18),
            LeaderboardEntry(name: "James Kim",    points: 2120, booksRead: 15),
            LeaderboardEntry(name: "Priya Nair",   points: 1890, booksRead: 14),
            LeaderboardEntry(name: "Marcus Lee",   points: 1540, booksRead: 11),
            LeaderboardEntry(name: "Aisha Brown",  points: 1200, booksRead: 9),
        ]
    }
}

// Controllers/LibrarianController.swift
class LibrarianController: ObservableObject {
    @Published var librarian: Librarian? = Librarian.sampleLibrarian
    @Published var recentCirculation: [CirculationRecord] = CirculationRecord.sampleRecords
    @Published var isLoading: Bool = false

    func approveReturn(_ record: CirculationRecord) {
        recentCirculation.removeAll { $0.id == record.id }
    }

    func markOverdue(_ record: CirculationRecord) {
        if let idx = recentCirculation.firstIndex(where: { $0.id == record.id }) {
            recentCirculation[idx] = CirculationRecord(
                bookTitle: record.bookTitle,
                userName: record.userName,
                action: .overdue,
                isOverdue: true
            )
        }
    }

    func searchMember(by name: String) -> [CirculationRecord] {
        recentCirculation.filter { $0.userName.localizedCaseInsensitiveContains(name) }
    }
}

