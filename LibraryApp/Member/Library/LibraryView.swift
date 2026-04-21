import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(sort: \Book.title) private var books: [Book]

    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    BookRow(book: book)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.pageBg)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.pageBg)
            .navigationTitle("Library")
        }
    }
}

