import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var sessions: [ReadingSession]

    let user: AppUser
    @State private var vm = HomeViewModel()
<<<<<<< HEAD
    @State private var selectedCategory = "All"
    
    private let categories = ["All", "Fiction", "Non-Fiction", "Science", "History", "Technology"]
=======
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
<<<<<<< HEAD
                LazyVStack(spacing: 24) {
                    
                    // 1. Search Bar (Type & Voice)
                    NavigationLink(destination: DiscoverView()) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.textSecondary)
                            Text("Search books...")
                                .foregroundColor(.textSecondary)
                            Spacer()
                            Image(systemName: "mic.fill")
                                .foregroundColor(.accent)
                        }
                        .padding(14)
                        .background(Color.surfaceBg)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // 2. Monthly Challenge Card
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .stroke(Color.accent.opacity(0.2), lineWidth: 6)
                            
                            // Mocking progress (e.g., 2 out of 5 books read)
                            Circle()
                                .trim(from: 0, to: 2.0 / 5.0)
                                .stroke(Color.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            
                            Text("2/5")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.textPrimary)
                        }
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Monthly Challenge")
                                .font(.headline)
                                .foregroundColor(.textPrimary)
                            Text("Read 5 books this month")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.cardBg)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)

                    // 3. Two Cards: Reading Streak & Total Points
                    HStack(spacing: 16) {
                        // Streak Card
                        VStack(spacing: 8) {
                            Image(systemName: "flame.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                            Text("\(vm.readingStreak)")
                                .font(.title.weight(.bold))
                                .foregroundColor(.textPrimary)
                            Text("Streak")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.cardBg)
                        .cornerRadius(16)

                        // Points Card
                        VStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .foregroundColor(.yellow)
                            Text("\(vm.rewardPoints)")
                                .font(.title.weight(.bold))
                                .foregroundColor(.textPrimary)
                            Text("Points")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.cardBg)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)

                    // 4. Quick Actions
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                Image(systemName: "viewfinder")
                                    .font(.title2)
                                    .foregroundColor(.accent)
                                Text("Scan")
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.cardBg)
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                Image(systemName: "compass")
                                    .font(.title2)
                                    .foregroundColor(.accent)
                                Text("Browse")
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.cardBg)
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                Image(systemName: "chair.fill")
                                    .font(.title2)
                                    .foregroundColor(.accent)
                                Text("Seats")
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.cardBg)
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)

                    // 1. Current Reading
                    if !vm.activeLoans.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Current Reading")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(vm.activeLoans.prefix(3)) { loan in
                                        if let book = loan.book {
                                            BookCoverCard(book: book, width: 100, height: 150)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    // 2. Top Picks
                    if !vm.featuredBooks.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Top Picks")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(vm.featuredBooks.prefix(5)) { book in
                                        BookCoverCard(book: book)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    
                    // 3. Siri Suggestions
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.accent)
                            Text("Siri Suggestions")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "book.fill")
                                .font(.title)
                                .foregroundColor(.accent)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Resume your session")
                                    .font(.headline)
                                    .foregroundColor(.textPrimary)
                                Text("Jump back into 'The Swift Guide'")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.textSecondary)
                        }
                        .padding(16)
                        .background(Color.cardBg)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }

                    // 4. Reading Goals
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reading Goals")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            Text("You are 2 books away from reaching your goal for this month. Keep up the great pace!")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 12) {
                                Button(action: {}) {
                                    Text("Keep Reading")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(Color.accent)
                                        .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {}) {
                                    Text("Adjust Goal")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(.accent)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(Color.accent.opacity(0.1))
                                        .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(16)
                        .background(Color.cardBg)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }
                    
                    // 5. Alert for overdue books
                    if let overdueLoan = vm.activeLoans.first(where: { $0.isOverdue }) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.coral)
                                Text("Overdue Book")
                                    .font(.headline.weight(.semibold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            Text("\"\(overdueLoan.book?.title ?? "Book")\" is overdue. Please return it as soon as possible.")
                                .font(.subheadline)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(16)
                        .background(Color.cardBg)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.coral.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.pageBg.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            // TODO: Notifications
                        }) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.accent)
                        }
                        
                        Button(action: {
                            // TODO: Profile Actions
                        }) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.accent)
                                .font(.title3)
                        }
                    }
                }
            }
=======
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
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
        }
        .task { await vm.load(user: user, modelContext: modelContext) }
    }
}

