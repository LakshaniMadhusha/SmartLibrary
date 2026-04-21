import SwiftUI
import SwiftData

struct HallsListView: View {
    @Query(sort: \Hall.floor) private var halls: [Hall]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(halls) { hall in
                        NavigationLink {
                            HallDetailView(hall: hall)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(hall.name)
                                        .font(.headline)
                                        .foregroundColor(.textPrimary)
                                    Text("Floor \(hall.floor) • \(hall.seats.count) seats")
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(16)
                            .background(Color.cardBg)
                            .cornerRadius(18)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(Color.pageBg.ignoresSafeArea())
            .navigationTitle("Halls")
        }
    }
}

