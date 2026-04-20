// Views/ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @ObservedObject var controller: ProfileController

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppTheme.Spacing.xl) {

                    // MARK: - Profile Header
                    profileHeader

                    // MARK: - Reading Stats
                    readingStats

                    // MARK: - Currently Borrowed
                    if !controller.borrowedBooks.isEmpty {
                        borrowedSection
                    }

                    // MARK: - Recommended
                    if !controller.recommendedBooks.isEmpty {
                        recommendedSection
                    }

                    // MARK: - Reserved
                    if !controller.reservedBooks.isEmpty {
                        reservedSection
                    }

                    Spacer(minLength: AppTheme.Spacing.xxxl)
                }
                .padding(.top, AppTheme.Spacing.base)
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.accentMuted)
                    .frame(width: 88, height: 88)
                Text(controller.user?.name.prefix(1) ?? "U")
                    .font(AppTheme.Fonts.custom(size: 36, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.accent)
            }
            .overlay(
                Circle()
                    .strokeBorder(AppTheme.Colors.accent, lineWidth: 2)
                    .frame(width: 92, height: 92)
            )

            VStack(spacing: 4) {
                Text(controller.user?.name ?? "")
                    .font(AppTheme.Fonts.title2)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text(controller.user?.email ?? "")
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text("\(controller.user?.points ?? 0) pts • Member since \(memberSinceText)")
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }

            // Badges
            if let badges = controller.user?.badges, !badges.isEmpty {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(badges) { badge in
                        VStack(spacing: 4) {
                            Image(systemName: "rosette")
                                .font(AppTheme.Fonts.custom(size: 22))
                                .foregroundColor(AppTheme.Colors.accentWarm)
                            Text(badge.title)
                                .font(AppTheme.Fonts.caption2)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        .padding(AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.shimmer)
                        .cornerRadius(AppTheme.Radius.md)
                    }
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.base)
    }

    private var memberSinceText: String {
        guard let date = controller.user?.memberSince else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }

    // MARK: - Reading Stats
    private var readingStats: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.md) {
            StatCard(title: "Books Read", value: "\(controller.user?.totalBooksRead ?? 0)", icon: "books.vertical")
            StatCard(title: "Day Streak", value: "🔥 \(controller.user?.currentStreak ?? 0)", icon: "flame", accentColor: AppTheme.Colors.borrowed)
            StatCard(title: "Reading Goal", value: "\(Int((controller.user?.readingGoal.progress ?? 0) * 100))%", icon: "target", accentColor: AppTheme.Colors.reserved)
            StatCard(title: "Points", value: "\(controller.user?.points ?? 0)", icon: "star.fill", accentColor: AppTheme.Colors.accentWarm)
        }
        .padding(.horizontal, AppTheme.Spacing.base)
    }

    // MARK: - Book Sections
    private var borrowedSection: some View {
        bookSection(title: "Currently Borrowed", books: controller.borrowedBooks, statusColor: AppTheme.Colors.borrowed, statusLabel: "Borrowed")
    }

    private var recommendedSection: some View {
        bookSection(title: "Recommended for You", books: controller.recommendedBooks, statusColor: AppTheme.Colors.accentLight, statusLabel: "Recommended")
    }

    private var reservedSection: some View {
        bookSection(title: "Reserved", books: controller.reservedBooks, statusColor: AppTheme.Colors.reserved, statusLabel: "Reserved")
    }

    private func bookSection(title: String, books: [Book], statusColor: Color, statusLabel: String) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: title)
                .padding(.horizontal, AppTheme.Spacing.base)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(books) { book in
                    HStack(spacing: AppTheme.Spacing.md) {
                        BookCoverCard(book: book, width: 55, height: 78, showRating: false)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title)
                                .font(AppTheme.Fonts.headline)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            Text(book.author)
                                .font(AppTheme.Fonts.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            if let due = book.dueDate {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .font(AppTheme.Fonts.custom(size: 10))
                                    Text("Due: \(formatDate(due))")
                                }
                                .font(AppTheme.Fonts.caption1)
                                .foregroundColor(AppTheme.Colors.borrowed)
                            }
                        }
                        Spacer()
                        StatusBadge(text: statusLabel, color: statusColor, small: true)
                    }
                    .padding(AppTheme.Spacing.md)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.Spacing.base)
                }
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Rewards View
struct RewardsView: View {
    @ObservedObject var controller: RewardsController

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppTheme.Spacing.xl) {
                    VStack(spacing: 4) {
                        Text("Rewards")
                            .font(AppTheme.Fonts.largeTitle)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Text("Earn points by reading more")
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.top, AppTheme.Spacing.base)

                    // Points Card
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("\(controller.totalPoints)")
                            .font(AppTheme.Fonts.custom(size: 52, weight: .bold))
                            .foregroundColor(.white)
                        Text("Total Points")
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.Spacing.xxl)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.Colors.accentWarm, Color(hex: "#E63946")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(AppTheme.Radius.xl)
                    .padding(.horizontal, AppTheme.Spacing.base)

                    // Leaderboard
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        SectionHeader(title: "Leaderboard", subtitle: "This month")
                            .padding(.horizontal, AppTheme.Spacing.base)

                        ForEach(Array(controller.leaderboard.enumerated()), id: \.element.id) { index, entry in
                            leaderboardRow(rank: index + 1, entry: entry)
                                .padding(.horizontal, AppTheme.Spacing.base)
                        }
                    }

                    Spacer(minLength: AppTheme.Spacing.xxxl)
                }
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private func leaderboardRow(rank: Int, entry: RewardsController.LeaderboardEntry) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Text("#\(rank)")
                .font(AppTheme.Fonts.headline)
                .foregroundColor(rank <= 3 ? AppTheme.Colors.accentWarm : AppTheme.Colors.textTertiary)
                .frame(width: 30)

            ZStack {
                Circle().fill(AppTheme.Colors.accentMuted).frame(width: 36, height: 36)
                Text(entry.name.prefix(1))
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("\(entry.booksRead) books read")
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }

            Spacer()

            Text("\(entry.points) pts")
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.accent)
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }
}

// MARK: - Librarian Dashboard View
struct LibrarianView: View {
    @ObservedObject var controller: LibrarianController

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppTheme.Spacing.xl) {

                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Staff Dashboard")
                                .font(AppTheme.Fonts.largeTitle)
                                .foregroundColor(AppTheme.Colors.textPrimary)
                            Text(controller.librarian?.name ?? "")
                                .font(AppTheme.Fonts.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.Spacing.base)
                    .padding(.top, AppTheme.Spacing.base)

                    // Stats
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.md) {
                        StatCard(title: "Total Books", value: "\(controller.librarian?.totalBooksManaged ?? 0)", icon: "books.vertical.fill")
                        StatCard(title: "Active Loans", value: "\(controller.librarian?.activeLoans ?? 0)", icon: "arrow.left.arrow.right", accentColor: AppTheme.Colors.reserved)
                        StatCard(title: "Overdue", value: "\(controller.librarian?.overdueItems ?? 0)", icon: "exclamationmark.circle", accentColor: AppTheme.Colors.overdue)
                        StatCard(title: "Returned Today", value: "24", icon: "checkmark.circle", accentColor: AppTheme.Colors.available)
                    }
                    .padding(.horizontal, AppTheme.Spacing.base)

                    // Recent Circulation
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        SectionHeader(title: "Recent Circulation", subtitle: "Today's activity")
                            .padding(.horizontal, AppTheme.Spacing.base)

                        ForEach(controller.recentCirculation) { record in
                            circulationRow(record: record)
                                .padding(.horizontal, AppTheme.Spacing.base)
                        }
                    }

                    Spacer(minLength: AppTheme.Spacing.xxxl)
                }
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private func circulationRow(record: CirculationRecord) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: actionIcon(record.action))
                .font(AppTheme.Fonts.custom(size: 14))
                .foregroundColor(actionColor(record.action))
                .frame(width: 32, height: 32)
                .background(actionColor(record.action).opacity(0.12))
                .cornerRadius(AppTheme.Radius.sm)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.bookTitle)
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text(record.userName)
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                StatusBadge(text: record.action.rawValue, color: actionColor(record.action), small: true)
                if record.isOverdue {
                    Text("OVERDUE")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.overdue)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    private func actionIcon(_ action: CirculationRecord.Action) -> String {
        switch action {
        case .borrowed:  return "arrow.up.right"
        case .returned:  return "arrow.down.left"
        case .reserved:  return "bookmark.fill"
        case .renewed:   return "arrow.clockwise"
        case .overdue:   return "exclamationmark.triangle"
        }
    }

    private func actionColor(_ action: CirculationRecord.Action) -> Color {
        switch action {
        case .borrowed:  return AppTheme.Colors.reserved
        case .returned:  return AppTheme.Colors.available
        case .reserved:  return AppTheme.Colors.accent
        case .renewed:   return AppTheme.Colors.accentWarm
        case .overdue:   return AppTheme.Colors.overdue
        }
    }
}

