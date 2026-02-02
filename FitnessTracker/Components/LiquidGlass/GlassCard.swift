import SwiftUI

/// Reusable modern card component
struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium
    var padding: CGFloat = DesignConstants.cardPadding
    var backgroundColor: Color? = nil

    init(
        cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium,
        padding: CGFloat = DesignConstants.cardPadding,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .liquidGlass(cornerRadius: cornerRadius, backgroundColor: backgroundColor)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: DesignConstants.spacingLarge) {
            GlassCard {
                VStack(alignment: .leading, spacing: DesignConstants.spacingSmall) {
                    Text("Bench Press")
                        .font(.headline)
                    Text("3 sets • 135 lbs")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            GlassCard(cornerRadius: DesignConstants.cornerRadiusLarge) {
                Text("Large Corner Radius")
            }
        }
        .padding()
    }
}
