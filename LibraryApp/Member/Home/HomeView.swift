import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var sessions: [ReadingSession]

    let user: AppUser
    @State private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Reading Streak and Points
                    HStack(spacing: 16) {
                        VStack {
                            Text("\(vm.readingStreak)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Day Streak")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .lightCard()

                        VStack {
                            Text("\(vm.rewardPoints)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Points")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .lightCard()
                    }

                    ReadingMinutesChart(sessions: sessions.filter { $0.userId == user.id })
                        .lightCard()

                    // Alerts
                    if let overdueLoan = vm.activeLoans.first(where: { $0.isOverdue }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overdue Alert")
                                .font(.headline)
                                .foregroundColor(.coral)
                            Text("\"\(overdueLoan.book?.title ?? "Book")\" is overdue.")
                                .font(.subheadline)
                        }
                        .lightCard()
                    }

                    // Current Loans
                    if !vm.activeLoans.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Current Loans")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            ForEach(vm.activeLoans) { loan in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(loan.book?.title ?? "Unknown")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Text("Due: \(loan.dueAt.formatted(date: .abbreviated, time: .omitted))")
                                            .font(.caption)
                                            .foregroundColor(loan.isOverdue ? .coral : .textSecondary)
                                    }
                                    Spacer()
                                    if loan.isOverdue {
                                        Text("Overdue")
                                            .font(.caption)
                                            .foregroundColor(.coral)
                                    }
                                }
                            }
                        }
                        .lightCard()
                    }

                    // Active Reservations
                    if !vm.activeReservations.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Active Reservations")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            ForEach(vm.activeReservations) { reservation in
                                HStack {
                                    Text(reservation.book?.title ?? "Unknown")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(reservation.status.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        .lightCard()
                    }

                    // Quick Actions
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Actions")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        HStack(spacing: 12) {
                            Button("Scan Book") {
                                // TODO: Implement scan
                            }
                            .buttonStyle(.secondaryButton)
                            .frame(maxWidth: .infinity)

                            Button("Reserve Seat") {
                                // TODO: Navigate to halls
                            }
                            .buttonStyle(.secondaryButton)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .lightCard()

                    if vm.isLoading {
                        ProgressView().tint(.primary)
                    }

                    if let msg = vm.errorMessage {
                        Text(msg).foregroundColor(.coral)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Featured")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        ForEach(vm.featuredBooks) { book in
                            BookRow(book: book)
                        }
                    }
                    .lightCard()
                }
                .padding(20)
            }
            .background(Color.pageBg.ignoresSafeArea())
            .navigationTitle("Home")
        }
        .task { await vm.load(user: user, modelContext: modelContext) }
    }
}

