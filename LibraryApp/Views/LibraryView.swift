// Views/LibraryView.swift
import SwiftUI

struct LibraryView: View {
    @ObservedObject var controller: LibraryController
    @State private var searchText = ""
    @State private var selectedFilter: LibraryFilter = .all

    enum LibraryFilter: String, CaseIterable {
        case all = "All"
        case available = "Available"
        case borrowed = "Borrowed"
        case reserved = "Reserved"
        case recommended = "Recommended"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Header
                VStack(spacing: AppTheme.Spacing.md) {
                    HStack {
                        Text("Library")
                            .font(AppTheme.Fonts.largeTitle)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        Spacer()
                        Button(action: { controller.toggleViewMode() }) {
                            Image(systemName: controller.isGridView ? "list.bullet" : "square.grid.2x2")
                                .font(AppTheme.Fonts.custom(size: 18))
                                .foregroundColor(AppTheme.Colors.textPrimary)
                        }
                    }
                    SearchBar(text: $searchText)
                }
                .padding(.horizontal, AppTheme.Spacing.base)
                .padding(.top, AppTheme.Spacing.base)
                .padding(.bottom, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.background)

                // MARK: - Filter Tabs
                filterTabs
                    .background(AppTheme.Colors.background)

                Divider()
                    .foregroundColor(AppTheme.Colors.border)

                // MARK: - Book List / Grid
                if controller.isGridView {
                    bookGrid
                } else {
                    bookList
                }
            }
            .background(AppTheme.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: - Filter Tabs
    private var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(LibraryFilter.allCases, id: \.self) { filter in
                    Button(action: { selectedFilter = filter }) {
                        Text(filter.rawValue)
                            .font(AppTheme.Fonts.subheadline)
                            .foregroundColor(selectedFilter == filter ? AppTheme.Colors.textOnAccent : AppTheme.Colors.textSecondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedFilter == filter ? AppTheme.Colors.accent : AppTheme.Colors.backgroundSecondary)
                            .cornerRadius(AppTheme.Radius.pill)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.base)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }

    // MARK: - Book Grid
    private var bookGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppTheme.Spacing.md) {
                ForEach(filteredBooks) { book in
                    VStack(alignment: .leading, spacing: 6) {
                        BookCoverCard(book: book, width: .infinity, height: 130)
                        Text(book.title)
                            .font(AppTheme.Fonts.caption1)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .lineLimit(1)
                        Text(book.author)
                            .font(AppTheme.Fonts.caption2)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(AppTheme.Spacing.base)
        }
    }

    // MARK: - Book List
    private var bookList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: AppTheme.Spacing.sm) {
                ForEach(filteredBooks) { book in
                    bookListRow(book: book)
                        .padding(.horizontal, AppTheme.Spacing.base)
                }
            }
            .padding(.vertical, AppTheme.Spacing.md)
        }
    }

    private func bookListRow(book: Book) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            BookCoverCard(book: book, width: 60, height: 86, showRating: false)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(book.title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(1)
                Text(book.author)
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                GenreTag(genre: book.genre)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(AppTheme.Fonts.custom(size: 10))
                        .foregroundColor(AppTheme.Colors.accentWarm)
                    Text(String(format: "%.1f", book.rating))
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AppTheme.Spacing.sm) {
                availabilityIndicator(book: book)
                Button(action: { controller.toggleBookmark(book) }) {
                    Image(systemName: "bookmark")
                        .font(AppTheme.Fonts.custom(size: 16))
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    private func availabilityIndicator(book: Book) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(book.isAvailable ? AppTheme.Colors.available : AppTheme.Colors.borrowed)
                .frame(width: 7, height: 7)
            Text(book.isAvailable ? "Available" : "Borrowed")
                .font(AppTheme.Fonts.caption1)
                .foregroundColor(book.isAvailable ? AppTheme.Colors.available : AppTheme.Colors.borrowed)
        }
    }

    private var filteredBooks: [Book] {
        let books = controller.books
        let filtered: [Book]
        switch selectedFilter {
        case .all:         filtered = books
        case .available:   filtered = books.filter { $0.isAvailable }
        case .borrowed:    filtered = books.filter { $0.isBorrowed }
        case .reserved:    filtered = books.filter { $0.isReserved }
        case .recommended: filtered = books.filter { $0.isRecommended }
        }
        if searchText.isEmpty { return filtered }
        return filtered.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.author.localizedCaseInsensitiveContains(searchText)
        }
    }
}

