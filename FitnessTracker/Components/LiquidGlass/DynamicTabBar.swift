import SwiftUI

/// Modern tab bar with circular icon buttons
struct DynamicTabBar: View {
    @Binding var selectedTab: Int
    @Binding var isCompact: Bool
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let tabs: [TabItem]

    var body: some View {
        HStack(spacing: DesignConstants.tabBarSpacing) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                TabButton(
                    tab: tab,
                    isSelected: selectedTab == index,
                    isCompact: isCompact
                ) {
                    withAnimation(.spring(
                        response: DesignConstants.springResponse,
                        dampingFraction: DesignConstants.springDampingFraction
                    )) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.horizontal, DesignConstants.spacingXLarge)
        .padding(.vertical, DesignConstants.spacingMedium)
        .frame(height: DesignConstants.tabBarHeightCompact)
        .background(
            Color(uiColor: .systemBackground)
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 10,
                    x: 0,
                    y: -2
                )
        )
        .animation(
            reduceMotion ? .none : .spring(
                response: DesignConstants.springResponse,
                dampingFraction: DesignConstants.springDampingFraction
            ),
            value: isCompact
        )
    }
}

struct TabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let isCompact: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Circular background
                Circle()
                    .fill(isSelected ? Color.primaryBlue : Color(uiColor: .systemGray5))
                    .frame(width: DesignConstants.tabBarIconSize, height: DesignConstants.tabBarIconSize)

                // Icon
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 24))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(isSelected ? .white : Color(uiColor: .systemGray))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
}

#Preview {
    VStack {
        Spacer()

        DynamicTabBar(
            selectedTab: .constant(0),
            isCompact: .constant(false),
            tabs: [
                TabItem(title: "Workout", icon: "dumbbell", selectedIcon: "dumbbell.fill"),
                TabItem(title: "History", icon: "calendar", selectedIcon: "calendar"),
                TabItem(title: "Stats", icon: "chart.line.uptrend.xyaxis", selectedIcon: "chart.line.uptrend.xyaxis"),
                TabItem(title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass")
            ]
        )
    }
    .background(Color(uiColor: .systemGroupedBackground))
}
