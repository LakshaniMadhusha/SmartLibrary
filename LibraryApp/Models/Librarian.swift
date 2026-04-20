// Models/Librarian.swift
import Foundation

struct Librarian: Identifiable, Codable {
    let id: UUID
    var name: String
    var staffId: String
    var email: String
    var profileImageName: String
    var role: Role
    var department: String
    var totalBooksManaged: Int
    var activeLoans: Int
    var overdueItems: Int

    enum Role: String, Codable {
        case senior = "Senior Librarian"
        case junior = "Junior Librarian"
        case assistant = "Library Assistant"
        case admin = "Administrator"
    }

    init(
        id: UUID = UUID(),
        name: String,
        staffId: String,
        email: String,
        profileImageName: String = "librarian_default",
        role: Role = .junior,
        department: String = "General",
        totalBooksManaged: Int = 0,
        activeLoans: Int = 0,
        overdueItems: Int = 0
    ) {
        self.id = id
        self.name = name
        self.staffId = staffId
        self.email = email
        self.profileImageName = profileImageName
        self.role = role
        self.department = department
        self.totalBooksManaged = totalBooksManaged
        self.activeLoans = activeLoans
        self.overdueItems = overdueItems
    }
}

struct CirculationRecord: Identifiable, Codable {
    let id: UUID
    var bookId: UUID
    var bookTitle: String
    var userId: UUID
    var userName: String
    var action: Action
    var date: Date
    var dueDate: Date?
    var isOverdue: Bool

    enum Action: String, Codable {
        case borrowed = "Borrowed"
        case returned = "Returned"
        case reserved = "Reserved"
        case renewed = "Renewed"
        case overdue = "Overdue"
    }

    init(
        id: UUID = UUID(),
        bookId: UUID = UUID(),
        bookTitle: String,
        userId: UUID = UUID(),
        userName: String,
        action: Action,
        date: Date = Date(),
        dueDate: Date? = nil,
        isOverdue: Bool = false
    ) {
        self.id = id
        self.bookId = bookId
        self.bookTitle = bookTitle
        self.userId = userId
        self.userName = userName
        self.action = action
        self.date = date
        self.dueDate = dueDate
        self.isOverdue = isOverdue
    }
}

// MARK: - Sample Data
extension Librarian {
    static let sampleLibrarian = Librarian(
        name: "Mike Johnson",
        staffId: "LIB-2024-001",
        email: "mike.johnson@library.com",
        profileImageName: "librarian_mike",
        role: .senior,
        department: "Fiction & Literature",
        totalBooksManaged: 1234,
        activeLoans: 456,
        overdueItems: 23
    )
}

extension CirculationRecord {
    static let sampleRecords: [CirculationRecord] = [
        CirculationRecord(bookTitle: "Tick Tack", userName: "Alice Brown", action: .borrowed, dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())),
        CirculationRecord(bookTitle: "The Big Empty", userName: "John Smith", action: .returned),
        CirculationRecord(bookTitle: "Don't Blink", userName: "Emma Wilson", action: .reserved),
        CirculationRecord(bookTitle: "Robert Craig", userName: "David Lee", action: .overdue, isOverdue: true),
        CirculationRecord(bookTitle: "Fiction Novel X", userName: "Lisa Chen", action: .renewed)
    ]
}

