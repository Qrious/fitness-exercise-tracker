import SwiftUI

/// View modifier that applies modern solid card styling
struct LiquidGlassModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    var cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium
    var addGlow: Bool = true
    var backgroundColor: Color? = nil

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor ?? Color(uiColor: .systemBackground))
                    .shadow(
                        color: .black.opacity(DesignConstants.cardShadowOpacity),
                        radius: DesignConstants.cardShadowRadius,
                        x: 0,
                        y: DesignConstants.cardShadowY
                    )
            )
    }
}

extension View {
    func liquidGlass(cornerRadius: CGFloat = DesignConstants.cornerRadiusMedium, addGlow: Bool = true, backgroundColor: Color? = nil) -> some View {
        self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius, addGlow: addGlow, backgroundColor: backgroundColor))
    }
}
