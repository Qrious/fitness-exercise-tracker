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
