import SwiftUI

// MARK: - Date Extensions
extension Date {
    /// Calculate day number since first workout
    func daysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: self)
        return (components.day ?? 0) + 1
    }

    /// Format date for display
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Format date for history list
    var historyFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

// MARK: - Color Extensions
extension Color {
    // Modern color palette matching the design
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 0.9) // Light blue/teal
    static let accentYellow = Color(red: 0.9, green: 0.95, blue: 0.5) // Lime/yellow accent
    static let cardBlue = Color(red: 0.55, green: 0.8, blue: 0.95) // Card blue background
    static let cardGreen = Color(red: 0.7, green: 0.9, blue: 0.5) // Card green/lime background
    static let cardPurple = Color(red: 0.6, green: 0.5, blue: 0.9) // Card purple background
    static let darkText = Color(red: 0.1, green: 0.1, blue: 0.1) // Dark text
    static let lightBackground = Color(red: 0.97, green: 0.97, blue: 0.98) // Light gray background

    // Legacy glass colors (keeping for backward compatibility)
    static let glassBackground = Color(white: 0.5, opacity: 0.1)
    static let glassBorder = Color.white.opacity(0.2)
}

// MARK: - View Extensions
extension View {
    /// Apply reduce motion check
    @ViewBuilder
    func animatedIf(_ condition: Bool) -> some View {
        if condition {
            self
        } else {
            self.animation(nil, value: UUID())
        }
    }
}
