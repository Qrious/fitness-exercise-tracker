import SwiftUI

/// View modifier that applies the Liquid Glass effect
struct LiquidGlassModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency

    var cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium
    var addGlow: Bool = true

    func body(content: Content) -> some View {
        if reduceTransparency {
            // Fallback for reduced transparency
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                )
        } else {
            content
                .background(
                    ZStack {
                        // Base glass layer
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.ultraThinMaterial)

                        // Additional blur for depth
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.regularMaterial.opacity(0.3))

                        // Gradient edge overlay for soft transitions
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(
                        color: addGlow ? Color.accentColor.opacity(DesignConstants.shadowOpacity) : .clear,
                        radius: addGlow ? DesignConstants.glowRadius : 0
                    )
                    .shadow(
                        color: .black.opacity(0.1),
                        radius: 8,
                        y: 4
                    )
                )
        }
    }
}

extension View {
    func liquidGlass(cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium, addGlow: Bool = true) -> some View {
        self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius, addGlow: addGlow))
    }
}
