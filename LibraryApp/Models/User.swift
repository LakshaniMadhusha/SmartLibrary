// Models/User.swift
import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var profileImageName: String
    var memberSince: Date
    var totalBooksRead: Int
    var currentStreak: Int
    var readingGoal: ReadingGoal
    var badges: [Badge]
    var points: Int

    struct ReadingGoal: Codable {
        var targetBooks: Int
        var completedBooks: Int
        var targetMinutesPerDay: Int
        var currentMinutesRead: Int

        var progress: Double {
            guard targetBooks > 0 else { return 0 }
            return Double(completedBooks) / Double(targetBooks)
        }
    }

    struct Badge: Identifiable, Codable {
        let id: UUID
        var title: String
        var imageName: String
        var earnedDate: Date

        init(id: UUID = UUID(), title: String, imageName: String, earnedDate: Date = Date()) {
            self.id = id
            self.title = title
            self.imageName = imageName
            self.earnedDate = earnedDate
        }
    }

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        profileImageName: String = "profile_default",
        memberSince: Date = Date(),
        totalBooksRead: Int = 0,
        currentStreak: Int = 0,
        readingGoal: ReadingGoal = ReadingGoal(targetBooks: 12, completedBooks: 0, targetMinutesPerDay: 30, currentMinutesRead: 0),
        badges: [Badge] = [],
        points: Int = 0
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageName = profileImageName
        self.memberSince = memberSince
        self.totalBooksRead = totalBooksRead
        self.currentStreak = currentStreak
        self.readingGoal = readingGoal
        self.badges = badges
        self.points = points
    }
}

// MARK: - Sample Data
extension User {
    static let sampleUser = User(
        name: "Sarah Evans",
        email: "sarah.evans@email.com",
        profileImageName: "profile_sarah",
        memberSince: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
        totalBooksRead: 47,
        currentStreak: 12,
        readingGoal: User.ReadingGoal(
            targetBooks: 24,
            completedBooks: 18,
            targetMinutesPerDay: 45,
            currentMinutesRead: 30
        ),
        badges: [
            User.Badge(title: "Bookworm", imageName: "badge_bookworm"),
            User.Badge(title: "Speed Reader", imageName: "badge_speed"),
            User.Badge(title: "Genre Explorer", imageName: "badge_explorer")
        ],
        points: 2456
    )
}

