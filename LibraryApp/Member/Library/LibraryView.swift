import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(sort: \Book.title) private var books: [Book]

    var body: some View {
        NavigationStack {
<<<<<<< HEAD
            Group {
                if books.isEmpty {
                    ContentUnavailableView("Library Empty", systemImage: "books.vertical", description: Text("You don't have any books added to your library yet."))
                } else {
                    List {
                        ForEach(books) { book in
                            BookRow(book: book)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.pageBg.ignoresSafeArea())
=======
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
>>>>>>> 50886afbd0b6837a06f6b0447ec8609636c51896
            .navigationTitle("Library")
        }
    }
}

