// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @ObservedObject var controller: HomeController
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {

                    // MARK: - Header
                    headerSection

                    // MARK: - Alerts Section
                    if !controller.alerts.isEmpty {
                        alertsSection
                    }

                    // MARK: - Quick Stats
                    quickStatsSection

                    // MARK: - Quick Actions
                    quickActionsSection

                    // MARK: - Active Loans
                    if !controller.activeLoans.isEmpty {
                        activeLoansSection
                    }

                    // MARK: - Active Reservations
                    if !controller.activeReservations.isEmpty {
                        activeReservationsSection
                    }

                    // MARK: - Currently Reading
                    if !controller.currentlyReading.isEmpty {
                        currentlyReadingSection
                    }

                    // MARK: - New Arrivals
                    upcomingSection

                    // MARK: - Top Picks
                    topPicksSection

                    Spacer(minLength: AppTheme.Spacing.xxxl)
                }
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .refreshable {
                controller.refreshData()
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text(controller.currentUser?.name.components(separatedBy: " ").first ?? "Reader")
                    .font(AppTheme.Fonts.title1)
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.accentMuted)
                    .frame(width: 44, height: 44)
                Text(controller.currentUser?.name.prefix(1) ?? "U")
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.accent)
            }
            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(AppTheme.Fonts.custom(size: 20))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    if !controller.alerts.isEmpty {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.base)
        .padding(.top, AppTheme.Spacing.base)
    }

    // MARK: - Alerts Section
    private var alertsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            SectionHeader(title: "Alerts", action: "\(controller.alerts.count)")
                .padding(.horizontal, AppTheme.Spacing.base)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(controller.alerts.prefix(3)) { alert in
                    alertCard(for: alert)
                        .padding(.horizontal, AppTheme.Spacing.base)
                }
                
                if controller.alerts.count > 3 {
                    HStack {
                        Text("+ \(controller.alerts.count - 3) more")
                            .font(AppTheme.Fonts.caption1)
                            .foregroundColor(AppTheme.Colors.accent)
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.Spacing.base)
                }
            }
        }
    }

    private func alertCard(for alert: DashboardAlert) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack {
                Image(systemName: alert.icon)
                    .font(AppTheme.Fonts.custom(size: 20))
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)
            .background(alert.color)
            .cornerRadius(AppTheme.Radius.md)

            VStack(alignment: .leading, spacing: 2) {
                Text(alert.title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(1)
                Text(alert.message)
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(AppTheme.Fonts.custom(size: 14))
                .foregroundColor(AppTheme.Colors.textTertiary)
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.md)
    }

    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.md) {
                statCard(
                    icon: "book.fill",
                    title: "Reading",
                    value: "\(controller.currentlyReading.count)",
                    color: AppTheme.Colors.accent
                )

                statCard(
                    icon: "bookmark.fill",
                    title: "Reserved",
                    value: "\(controller.activeReservations.count)",
                    color: AppTheme.Colors.accentWarm
                )

                statCard(
                    icon: "paperclip.circle.fill",
                    title: "Loans",
                    value: "\(controller.activeLoans.count)",
                    color: AppTheme.Colors.available
                )
            }

            HStack(spacing: AppTheme.Spacing.md) {
                statCard(
                    icon: "flame.fill",
                    title: "Streak",
                    value: "\(controller.currentUser?.currentStreak ?? 0)",
                    color: AppTheme.Colors.accentWarm,
                    subtitle: "days"
                )

                statCard(
                    icon: "star.fill",
                    title: "Points",
                    value: "\(controller.currentUser?.points ?? 0)",
                    color: AppTheme.Colors.accent,
                    subtitle: "rewards"
                )

                Color.clear
            }
        }
        .padding(.horizontal, AppTheme.Spacing.base)
    }

    private func statCard(
        icon: String,
        title: String,
        value: String,
        color: Color,
        subtitle: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(AppTheme.Fonts.custom(size: 14))
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(AppTheme.Fonts.title2)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Text(title)
                .font(AppTheme.Fonts.caption1)
                .foregroundColor(AppTheme.Colors.textSecondary)
                
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.md)
    }

    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Quick Actions")
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.base)

            HStack(spacing: AppTheme.Spacing.sm) {
                quickActionButton(
                    icon: "magnifyingglass",
                    label: "Search",
                    color: AppTheme.Colors.accent
                )
                quickActionButton(
                    icon: "list.bullet",
                    label: "My Books",
                    color: AppTheme.Colors.accentWarm
                )
                quickActionButton(
                    icon: "chair.lounge",
                    label: "Reserve Seat",
                    color: AppTheme.Colors.available
                )
                quickActionButton(
                    icon: "bell.badge",
                    label: "Alerts",
                    color: Color.red
                )
            }
            .padding(.horizontal, AppTheme.Spacing.base)
        }
    }

    private func quickActionButton(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(AppTheme.Fonts.custom(size: 24))
                .foregroundColor(color)

            Text(label)
                .font(AppTheme.Fonts.caption1)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.md)
    }

    // MARK: - Active Loans Section
    private var activeLoansSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Active Loans", action: "View all")
                .padding(.horizontal, AppTheme.Spacing.base)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(controller.activeLoans.prefix(2)) { loan in
                    loanCard(for: loan)
                        .padding(.horizontal, AppTheme.Spacing.base)
                }
            }
        }
    }

    private func loanCard(for loan: LoanInfo) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            BookCoverCard(
                book: loan.book,
                width: 50,
                height: 72,
                showRating: false
            )

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(loan.book.title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(2)

                Text("by \(loan.book.author)")
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .lineLimit(1)

                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "calendar")
                        .font(AppTheme.Fonts.custom(size: 12))
                    Text(loan.isOverdue ? 
                        "\(abs(loan.daysRemaining)) days overdue" : 
                        "Due in \(loan.daysRemaining) days")
                        .font(AppTheme.Fonts.caption2)
                }
                .foregroundColor(loan.isOverdue ? Color.red : (loan.isDueSoon ? Color.orange : AppTheme.Colors.textTertiary))
            }

            Spacer()

            VStack(spacing: AppTheme.Spacing.xs) {
                Button(action: {}) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(AppTheme.Fonts.custom(size: 24))
                        .foregroundColor(AppTheme.Colors.accent)
                }

                Text("Renew")
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.accent)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.md)
    }

    // MARK: - Active Reservations Section
    private var activeReservationsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Reservations", subtitle: "\(controller.activeReservations.count) active")
                .padding(.horizontal, AppTheme.Spacing.base)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(controller.activeReservations.prefix(2)) { reservation in
                    reservationCard(for: reservation)
                        .padding(.horizontal, AppTheme.Spacing.base)
                }
            }
        }
    }

    private func reservationCard(for reservation: ReservationInfo) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ZStack(alignment: .center) {
                Circle()
                    .fill(AppTheme.Colors.accentMuted)
                    .frame(width: 50, height: 50)
                
                Text("#\(reservation.position)")
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.accent)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(reservation.book.title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(1)

                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "person.2.fill")
                        .font(AppTheme.Fonts.custom(size: 12))
                        .foregroundColor(AppTheme.Colors.accent)
                    Text("Position \(reservation.position) in queue")
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                StatusBadge(
                    text: "Reserved",
                    color: AppTheme.Colors.reserved,
                    small: true
                )
                Text("\(reservation.daysSinceReserved)d ago")
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.md)
    }

    // MARK: - Currently Reading Section
    private var currentlyReadingSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Currently Reading", action: "See all")
                .padding(.horizontal, AppTheme.Spacing.base)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(controller.currentlyReading) { book in
                        currentlyReadingCard(book: book)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.base)
            }
        }
    }

    private func currentlyReadingCard(book: Book) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            BookCoverCard(book: book, width: 70, height: 100, showRating: false)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text(book.title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(2)
                Text(book.author)
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Spacer()
                ReadingProgressBar(progress: book.readingProgress)
                Text("\(book.currentPage) of \(book.totalPages) pages")
                    .font(AppTheme.Fonts.caption2)
                    .foregroundColor(AppTheme.Colors.textTertiary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .frame(width: 260)
        .cardStyle()
    }

    // MARK: - Upcoming Section
    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "New Arrivals", subtitle: "Fresh this week", action: "See all")
                .padding(.horizontal, AppTheme.Spacing.base)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(controller.newArrivals) { book in
                        BookCoverCard(book: book, width: 100, height: 145)
                            .frame(width: 100)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.base)
            }
        }
    }

    // MARK: - Top Picks
    private var topPicksSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Top Picks For You", subtitle: "Based on your reading history")
                .padding(.horizontal, AppTheme.Spacing.base)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(controller.topPicks) { book in
                    topPickRow(book: book)
                        .padding(.horizontal, AppTheme.Spacing.base)
                }
            }
        }
    }

    private func topPickRow(book: Book) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            BookCoverCard(book: book, width: 55, height: 78, showRating: false)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text(book.author)
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                GenreTag(genre: book.genre)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(AppTheme.Fonts.custom(size: 11))
                        .foregroundColor(AppTheme.Colors.accentWarm)
                    Text(String(format: "%.1f", book.rating))
                        .font(AppTheme.Fonts.subheadline)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                StatusBadge(
                    text: book.isAvailable ? "Available" : "Borrowed",
                    color: book.isAvailable ? AppTheme.Colors.available : AppTheme.Colors.borrowed,
                    small: true
                )
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }
}

