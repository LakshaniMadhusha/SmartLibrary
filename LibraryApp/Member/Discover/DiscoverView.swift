import SwiftUI
import SwiftData

struct DiscoverView: View {
    @Query(sort: \Book.createdAt, order: .reverse) private var books: [Book]
    @State private var query = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    TextField("Search books, authors, genres", text: $query)
                        .inputStyle()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Browse")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                        ForEach(filtered) { book in
                            BookRow(book: book)
                        }
                    }
                    .lightCard()
                }
                .padding(20)
            }
            .background(Color.pageBg.ignoresSafeArea())
            .navigationTitle("Discover")
        }
    }

    private var filtered: [Book] {
        guard !query.isEmpty else { return books }
        return books.filter {
            $0.title.localizedCaseInsensitiveContains(query)
            || $0.author.localizedCaseInsensitiveContains(query)
            || $0.genre.localizedCaseInsensitiveContains(query)
        }
    }
}

