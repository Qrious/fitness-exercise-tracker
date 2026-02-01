import SwiftUI

/// Custom tab bar with dynamic height based on scroll state
struct DynamicTabBar: View {
    @Binding var selectedTab: Int
    @Binding var isCompact: Bool
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let tabs: [TabItem]

    var body: some View {
        HStack(spacing: 0) {
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
        .frame(height: isCompact ? DesignConstants.tabBarHeightCompact : DesignConstants.tabBarHeightExpanded)
        .liquidGlass(cornerRadius: 0, addGlow: false)
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
            VStack(spacing: DesignConstants.spacingXSmall) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 24))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)

                if !isCompact {
                    Text(tab.title)
                        .font(.caption)
                        .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
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
