// Models/Book.swift
import Foundation

struct Book: Identifiable, Codable {
    let id: UUID
    var title: String
    var author: String
    var genre: Genre
    var coverImageName: String
    var rating: Double
    var totalPages: Int
    var currentPage: Int
    var isAvailable: Bool
    var isBorrowed: Bool
    var isReserved: Bool
    var isRecommended: Bool
    var synopsis: String
    var dueDate: Date?
    var borrowedDate: Date?

    var readingProgress: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(totalPages)
    }

    enum Genre: String, Codable, CaseIterable {
        case fiction = "Fiction"
        case literature = "Literature"
        case thriller = "Thriller"
        case mystery = "Mystery"
        case comics = "Comics & Novels"
        case science = "Science"
        case history = "History"
        case biography = "Biography"
    }

    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        genre: Genre,
        coverImageName: String = "book_default",
        rating: Double = 0,
        totalPages: Int = 300,
        currentPage: Int = 0,
        isAvailable: Bool = true,
        isBorrowed: Bool = false,
        isReserved: Bool = false,
        isRecommended: Bool = false,
        synopsis: String = "",
        dueDate: Date? = nil,
        borrowedDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.genre = genre
        self.coverImageName = coverImageName
        self.rating = rating
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.isAvailable = isAvailable
        self.isBorrowed = isBorrowed
        self.isReserved = isReserved
        self.isRecommended = isRecommended
        self.synopsis = synopsis
        self.dueDate = dueDate
        self.borrowedDate = borrowedDate
    }
}

// MARK: - Sample Data
extension Book {
    static let sampleBooks: [Book] = [
        Book(
            title: "Tick Tack",
            author: "James R.",
            genre: .thriller,
            coverImageName: "cover_tick_tack",
            rating: 4.5,
            totalPages: 320,
            currentPage: 120,
            isAvailable: false,
            isBorrowed: true,
            synopsis: "A gripping thriller that keeps you on the edge of your seat.",
            dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            borrowedDate: Date()
        ),
        Book(
            title: "The Big Empty",
            author: "Sarah M.",
            genre: .fiction,
            coverImageName: "cover_big_empty",
            rating: 4.2,
            totalPages: 280,
            isAvailable: true,
            isRecommended: true,
            synopsis: "A journey through the unknown landscapes of the human mind."
        ),
        Book(
            title: "Robert Craig",
            author: "R. Craig",
            genre: .mystery,
            coverImageName: "cover_robert_craig",
            rating: 4.7,
            totalPages: 400,
            isAvailable: true,
            synopsis: "A masterful mystery that unfolds across three generations."
        ),
        Book(
            title: "Don't Blink",
            author: "K. Patterson",
            genre: .thriller,
            coverImageName: "cover_dont_blink",
            rating: 4.3,
            totalPages: 350,
            isAvailable: false,
            isReserved: true,
            synopsis: "When you blink, everything changes. When you don't — even more so."
        )
    ]
}

