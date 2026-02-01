import SwiftUI

/// Reusable glass card component
struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium
    var padding: CGFloat = DesignConstants.spacingLarge

    init(
        cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium,
        padding: CGFloat = DesignConstants.spacingLarge,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .liquidGlass(cornerRadius: cornerRadius)
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
