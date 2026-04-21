# � LibraryApp - Full-Stack iOS Library Platform

A comprehensive iOS library platform designed to help students discover, access, verify, and engage with books and study spaces. Students can explore the library catalog, scan book covers, reserve titles, book study rooms or individual seats, track their reading progress, complete quizzes, and earn rewards through meaningful reading activities. Librarians benefit from a dedicated staff dashboard for managing circulation, catalog updates, demand analysis, and operational alerts.

## 🔧 View-by-View Update Examples

This file contains practical code examples for updating each major view in your LibraryApp to use the new HIG-compliant theme.

---

## HomeView - Main Dashboard

### Before: Custom styling scattered throughout
```swift
// ❌ OLD - Inconsistent styling
VStack(spacing: 16) {
    Text("Welcome, \(user.name)")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(Color(hex: "#1A1A1A"))
    
    HStack {
        VStack(alignment: .leading) {
            Text("5")
                .font(.system(size: 24, weight: .semibold))
            Text("Books Borrowed")
                .font(.system(size: 14))
        }
        .padding(16)
        .background(Color(hex: "#FFFFFF"))
        .cornerRadius(12)
        .shadow(radius: 8)
    }
    
    Button(action: {}) {
        Text("Browse Library")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(Color(hex: "#2D6A4F"))
    }
}
```

### After: Semantic, consistent, and accessible
```swift
// ✅ NEW - Clean, consistent, accessible
VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
    // Header
    Text("Welcome, \(user.name)")
        .font(AppTheme.Fonts.title1)
        .foregroundColor(AppTheme.Colors.textPrimary)
        .accessibilityAddTraits(.isHeader)
    
    // Stats
    StatCard(
        title: "Books Borrowed",
        value: "5",
        icon: "book.fill",
        accentColor: AppTheme.Colors.warning
    )
    
    // Action Button
    Button("Browse Library") {
        navigateToLibrary()
    }
    .higButtonStyle()
}
.padding(AppTheme.Spacing.base)
```

---

## LibraryView - Book Listing

### Before: Manual styling
```swift
// ❌ OLD - Manual implementation
ScrollView {
    VStack(spacing: 12) {
        ForEach(books) { book in
            HStack {
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.system(size: 17, weight: .semibold))
                    Text(book.author)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#5C5C5C"))
                }
                Spacer()
                if book.isAvailable {
                    Text("Available")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color(hex: "#40916C"))
                        .cornerRadius(8)
                }
            }
            .padding(12)
            .background(Color(hex: "#FFFFFF"))
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}
```

### After: Component-based, accessible
```swift
// ✅ NEW - Semantic, reusable, accessible
ScrollView {
    VStack(spacing: AppTheme.Spacing.md) {
        ForEach(books) { book in
            HStack(spacing: AppTheme.Spacing.base) {
                BookCoverCard(book: book, width: 60, height: 90)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(book.title)
                        .font(AppTheme.Fonts.headline)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text(book.author)
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    Spacer()
                    
                    // Status using semantic color
                    StatusBadge(
                        text: book.status,
                        color: book.isAvailable
                            ? AppTheme.Colors.success
                            : AppTheme.Colors.warning
                    )
                }
                
                Spacer()
            }
            .cardStyle()
            .padding(AppTheme.Spacing.xs)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(book.title) by \(book.author)")
            .accessibilityValue("Status: \(book.status)")
        }
    }
    .padding(AppTheme.Spacing.base)
}
```

---

## SeatsView - Seat Reservation

### Before: Hardcoded colors
```swift
// ❌ OLD - Hardcoded, no accessibility
LazyVGrid(columns: columns) {
    ForEach(seats) { seat in
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    seat.isOccupied ? Color(hex: "#FFCDB2") :
                    seat.isSelected ? Color(hex: "#2D6A4F") :
                    Color(hex: "#B7E4C7")
                )
            
            Text("\(seat.number)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(height: 60)
        .onTapGesture {
            selectSeat(seat)
        }
    }
}
```

### After: Semantic, accessible
```swift
// ✅ NEW - Semantic colors, accessible, adaptive
LazyVGrid(columns: columns) {
    ForEach(seats) { seat in
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                .fill(
                    seat.isOccupied ? AppTheme.Colors.seatOccupied :
                    seat.isSelected ? AppTheme.Colors.seatSelected :
                    AppTheme.Colors.seatAvailable
                )
            
            Text("\(seat.number)")
                .font(AppTheme.Fonts.caption1)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .frame(minHeight: 60)
        .onTapGesture {
            selectSeat(seat)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Seat \(seat.number)")
        .accessibilityValue(
            seat.isOccupied ? "Occupied" :
            seat.isSelected ? "Selected" :
            "Available"
        )
        .accessibility(hint: "Double tap to select")
    }
}
.padding(AppTheme.Spacing.base)
```

---

## AuthViews - Login/Registration

### Before: Custom form styling
```swift
// ❌ OLD - Manual form styling everywhere
VStack(spacing: 16) {
    TextField("Email", text: $email)
        .padding(12)
        .border(Color(hex: "#E0DDD8"))
        .cornerRadius(8)
    
    SecureField("Password", text: $password)
        .padding(12)
        .border(Color(hex: "#E0DDD8"))
        .cornerRadius(8)
    
    Button(action: login) {
        Text("Sign In")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(Color(hex: "#2D6A4F"))
            .cornerRadius(12)
    }
    .disabled(email.isEmpty || password.isEmpty)
}
```

### After: Accessible forms with validation
```swift
// ✅ NEW - Accessible, validated, consistent
VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
    TextField("Email", text: $email)
        .accessibleLabel("Email Address", isRequired: true)
        .higTextFieldStyle()
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .autocapitalization(.none)
    
    SecureField("Password", text: $password)
        .accessibleLabel("Password", isRequired: true)
        .higTextFieldStyle()
        .textContentType(.password)
    
    HStack {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(
                passwordIsValid ? AppTheme.Colors.success : AppTheme.Colors.textTertiary
            )
        Text("Min 8 characters")
            .font(AppTheme.Fonts.caption2)
            .foregroundColor(AppTheme.Colors.textSecondary)
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("Password requirements: minimum 8 characters")
    
    Spacer(minLength: AppTheme.Spacing.base)
    
    Button("Sign In") {
        login()
    }
    .higButtonStyle()
    .disabled(email.isEmpty || !passwordIsValid)
    
    Button("Create Account") {
        showSignUp()
    }
    .secondaryButtonStyle()
}
.padding(AppTheme.Spacing.base)
```

---

## ProfileView - User Information

### Before: Inconsistent styling
```swift
// ❌ OLD - Mixed styling
ScrollView {
    VStack(spacing: 16) {
        Text("Profile")
            .font(.system(size: 28, weight: .bold))
        
        HStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "#2D6A4F"))
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.system(size: 18, weight: .semibold))
                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#5C5C5C"))
            }
        }
        .padding(16)
        .background(Color(hex: "#FFFFFF"))
        .cornerRadius(12)
        
        // More profile content...
    }
}
```

### After: Modern, accessible profile
```swift
// ✅ NEW - Modern, accessible, consistent
ScrollView {
    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
        // Header
        Text("Profile")
            .font(AppTheme.Fonts.title1)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .accessibilityAddTraits(.isHeader)
        
        // User Info Card
        HStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(AppTheme.Colors.accent)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text(user.name)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text(user.email)
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "star.fill")
                        .font(AppTheme.Fonts.system(size: 12))
                    Text("\(user.membershipTier)")
                        .font(AppTheme.Fonts.caption1)
                }
                .foregroundColor(AppTheme.Colors.accentWarm)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.base)
        .cardStyle()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("User: \(user.name), Email: \(user.email)")
        
        // Quick Stats
        HStack(spacing: AppTheme.Spacing.md) {
            StatCard(title: "Books Read", value: "\(user.booksRead)", icon: "books.vertical.fill")
            StatCard(title: "Points", value: "\(user.rewardPoints)", icon: "star.fill")
        }
        
        // More profile content...
    }
    .padding(AppTheme.Spacing.base)
}
```

---

## Alerts & Notifications

### Before: Hardcoded styling
```swift
// ❌ OLD - Inconsistent alerts
if let alert = alertMessage {
    HStack {
        Image(systemName: "exclamationmark.circle.fill")
            .foregroundColor(.orange)
        Text(alert)
            .font(.system(size: 14))
            .foregroundColor(Color(hex: "#1A1A1A"))
    }
    .padding(12)
    .background(Color(hex: "#FFF3E0"))
    .cornerRadius(8)
}
```

### After: Semantic alerts
```swift
// ✅ NEW - Semantic, accessible alerts
if let alert = alertMessage {
    HStack(spacing: AppTheme.Spacing.md) {
        // Icon matches severity
        Image(systemName: alert.isError ? "xmark.circle.fill" : "exclamationmark.circle.fill")
            .font(AppTheme.Fonts.system(size: 18))
            .foregroundColor(alert.isError ? AppTheme.Colors.error : AppTheme.Colors.warning)
        
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(alert.title)
                .font(AppTheme.Fonts.headline)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text(alert.message)
                .font(AppTheme.Fonts.callout)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        
        Spacer()
        
        Button(action: { dismissAlert() }) {
            Image(systemName: "xmark")
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
    .padding(AppTheme.Spacing.base)
    .background(
        alert.isError
            ? AppTheme.Colors.error.opacity(0.08)
            : AppTheme.Colors.warning.opacity(0.08)
    )
    .cornerRadius(AppTheme.Radius.lg)
    .overlay(
        RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
            .stroke(
                alert.isError
                    ? AppTheme.Colors.error.opacity(0.3)
                    : AppTheme.Colors.warning.opacity(0.3),
                lineWidth: 1
            )
    )
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(alert.isError ? "Error" : "Warning"): \(alert.title)")
    .accessibilityHint(alert.message)
}
```

---

## Best Practices Summary

### ✅ DO:
- Use `AppTheme.Colors.*` for all colors
- Use `AppTheme.Fonts.*` for all fonts
- Use `AppTheme.Spacing.*` for all spacing
- Add `.accessibleLabel()` to form inputs
- Use `.higButtonStyle()` for buttons
- Test in dark mode
- Add accessibility hints to complex components

### ❌ DON'T:
- Use hardcoded hex colors
- Use `.custom()` font sizing
- Use hardcoded spacing values
- Forget accessibility labels
- Skip dark mode testing
- Use custom button implementations
- Assume sufficient contrast

---

## Migration Priority

1. **High Priority** (Most visible)
   - HomeView buttons
   - LibraryView book cards
   - Primary action buttons

2. **Medium Priority**
   - Form inputs
   - Status indicators
   - Navigation elements

3. **Low Priority** (Less visible)
   - Helper text
   - Loading states
   - Error messages

---

## Testing Each View

```swift
struct ViewName_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode iPhone
            ViewName()
                .preferredColorScheme(.light)
                .previewDisplayName("Light - iPhone")
            
            // Dark mode iPhone
            ViewName()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark - iPhone")
            
            // Accessibility text sizes
            ViewName()
                .environment(\.sizeCategory, .accessibilityLarge)
                .preferredColorScheme(.light)
                .previewDisplayName("Large Text")
        }
    }
}
```

---

## Questions?

Refer to the main guides:
- [DESIGN_GUIDE.md](../../LibraryApp/LibraryApp/DESIGN_GUIDE.md) - Design patterns
- [IMPLEMENTATION_GUIDE.md](../../IMPLEMENTATION_GUIDE.md) - General implementation
- [README_DESIGN_UPDATES.md](../../LibraryApp/README_DESIGN_UPDATES.md) - Summary

Happy refactoring! ✨
