import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    @State private var isTabBarCompact = false

    let tabs = [
        TabItem(title: "Workout", icon: "dumbbell", selectedIcon: "dumbbell.fill"),
        TabItem(title: "History", icon: "calendar", selectedIcon: "calendar"),
        TabItem(title: "Stats", icon: "chart.line.uptrend.xyaxis", selectedIcon: "chart.line.uptrend.xyaxis"),
        TabItem(title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Content
            ZStack {
                switch selectedTab {
                case 0:
                    ActiveWorkoutView(context: viewContext)
                case 1:
                    HistoryView(context: viewContext)
                case 2:
                    StatisticsView(context: viewContext)
                case 3:
                    SearchView()
                default:
                    ActiveWorkoutView(context: viewContext)
                }
            }

            // Custom Tab Bar
            DynamicTabBar(
                selectedTab: $selectedTab,
                isCompact: $isTabBarCompact,
                tabs: tabs
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
