// Views/Components/SharedComponents.swift
import SwiftUI

// MARK: - Book Cover Card
struct BookCoverCard: View {
    let book: Book
    var width: CGFloat = 90
    var height: CGFloat = 130
    var showRating: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            ZStack(alignment: .bottomLeading) {
                // Cover placeholder with gradient
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .fill(coverGradient)
                    .frame(width: width, height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                            .stroke(AppTheme.Colors.border, lineWidth: 0.5)
                    )
                    .overlay(
                        VStack {
                            Spacer()
                            Text(book.title)
                                .font(AppTheme.Fonts.caption1)
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .padding(6)
                        }
                    )

                // Status badge
                if book.isBorrowed {
                    StatusBadge(text: "Borrowed", color: AppTheme.Colors.borrowed)
                        .padding(6)
                } else if book.isReserved {
                    StatusBadge(text: "Reserved", color: AppTheme.Colors.reserved)
                        .padding(6)
                }
            }

            if showRating && book.rating > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(AppTheme.Fonts.custom(size: 9))
                        .foregroundColor(AppTheme.Colors.accentWarm)
                    Text(String(format: "%.1f", book.rating))
                        .font(AppTheme.Fonts.caption2)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
        }
    }

    var coverGradient: LinearGradient {
        let colors: [(Color, Color)] = [
            (Color(hex: "#667eea"), Color(hex: "#764ba2")),
            (Color(hex: "#f093fb"), Color(hex: "#f5576c")),
            (Color(hex: "#4facfe"), Color(hex: "#00f2fe")),
            (Color(hex: "#43e97b"), Color(hex: "#38f9d7")),
            (Color(hex: "#fa709a"), Color(hex: "#fee140")),
        ]
        let pair = colors[abs(book.title.hashValue) % colors.count]
        return LinearGradient(colors: [pair.0, pair.1], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let text: String
    let color: Color
    var small: Bool = false

    var body: some View {
        Text(text)
            .font(small ? AppTheme.Fonts.caption2 : AppTheme.Fonts.caption1)
            .foregroundColor(.white)
            .padding(.horizontal, small ? 6 : 8)
            .padding(.vertical, small ? 2 : 4)
            .background(color)
            .cornerRadius(AppTheme.Radius.pill)
    }
}

// MARK: - Genre Tag
struct GenreTag: View {
    let genre: Book.Genre

    var body: some View {
        Text(genre.rawValue)
            .font(AppTheme.Fonts.caption1)
            .foregroundColor(AppTheme.Colors.accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(AppTheme.Colors.accentMuted)
            .cornerRadius(AppTheme.Radius.pill)
    }
}

// MARK: - Reading Progress Bar
struct ReadingProgressBar: View {
    let progress: Double
    var height: CGFloat = 6
    var showLabel: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if showLabel {
                HStack {
                    Text("Reading Progress")
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.accent)
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(AppTheme.Colors.border)
                        .frame(height: height)
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(AppTheme.Colors.accent)
                        .frame(width: geo.size.width * progress, height: height)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: height)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var accentColor: Color = AppTheme.Colors.accent

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(AppTheme.Fonts.custom(size: 14))
                    .foregroundColor(accentColor)
                    .frame(width: 28, height: 28)
                    .background(accentColor.opacity(0.12))
                    .cornerRadius(AppTheme.Radius.sm)
                Spacer()
            }
            Text(value)
                .font(AppTheme.Fonts.title2)
                .foregroundColor(AppTheme.Colors.textPrimary)
            Text(title)
                .font(AppTheme.Fonts.caption1)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(AppTheme.Spacing.base)
        .cardStyle()
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var action: String? = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
            Spacer()
            if let action = action {
                Button(action: { onAction?() }) {
                    Text(action)
                        .font(AppTheme.Fonts.subheadline)
                        .foregroundColor(AppTheme.Colors.accent)
                }
            }
        }
    }
}

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isFullWidth: Bool = true

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textOnAccent)
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(AppTheme.Colors.accent)
            .cornerRadius(AppTheme.Radius.lg)
        }
        .disabled(isLoading)
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search books, authors..."

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.textTertiary)
            TextField(placeholder, text: $text)
                .font(AppTheme.Fonts.body)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.backgroundSecondary)
        .cornerRadius(AppTheme.Radius.lg)
    }
}

