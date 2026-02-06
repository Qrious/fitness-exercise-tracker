import SwiftUI
import CoreData
import Combine

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: HomeViewModel
    @State private var navigateToWorkout = false
    @State private var selectedWorkout: WorkoutEntity?
    @State private var showingFullCalendar = false
    @State private var selectedDate = Date()

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Light background
                Color.white
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header
                        headerSection

                        // Quick Start Workout Card
                        quickStartCard

                        // This Week Calendar
                        weekCalendarSection

                        // Recent Activity
                        recentActivitySection
                    }
                    .padding()
                    .padding(.bottom, 80)
                }
            }
            .navigationDestination(isPresented: $navigateToWorkout) {
                ActiveWorkoutView(context: viewContext, autoStart: true)
                    .navigationBarBackButtonHidden(true)
            }
            .sheet(item: $selectedWorkout) { workout in
                WorkoutDetailView(workout: workout)
            }
            .sheet(isPresented: $showingFullCalendar) {
                FullCalendarView(
                    selectedDate: $selectedDate,
                    workoutDates: viewModel.workoutDates,
                    onDateSelected: { date in
                        showingFullCalendar = false
                        viewModel.filterWorkoutsByDate(date)
                    }
                )
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hello Athlete 👋")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            Text("Ready to crush it?")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    // MARK: - Quick Start Card
    private var quickStartCard: some View {
        Button(action: {
            navigateToWorkout = true
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.5))
                        .frame(width: 60, height: 60)

                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.title2)
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick Start")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("Begin your workout")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }

                Spacer()

                // Start Button
                Text("START")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color(red: 0.4, green: 0.8, blue: 0.7))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.white)
                    .cornerRadius(20)
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.7, green: 0.9, blue: 0.4), Color(red: 0.4, green: 0.8, blue: 0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(24)
            .shadow(color: Color(red: 0.7, green: 0.9, blue: 0.4).opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Week Calendar
    private var weekCalendarSection: some View {
        VStack(spacing: 16) {
            // Month/Year header with expand button
            HStack {
                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                Button(action: {
                    showingFullCalendar = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.subheadline)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal, 4)

            // Scrollable week view
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.scrollableWeeks, id: \.id) { week in
                            ForEach(week.days, id: \.date) { day in
                                Button(action: {
                                    selectedDate = day.date
                                    viewModel.filterWorkoutsByDate(day.date)
                                }) {
                                    VStack(spacing: 8) {
                                        Text(day.dayName)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)

                                        ZStack {
                                            if day.isSelected {
                                                Circle()
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [Color(red: 0.7, green: 0.9, blue: 0.4), Color(red: 0.4, green: 0.8, blue: 0.7)],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 44, height: 44)
                                            } else if day.isToday {
                                                Circle()
                                                    .stroke(
                                                        LinearGradient(
                                                            colors: [Color(red: 0.7, green: 0.9, blue: 0.4), Color(red: 0.4, green: 0.8, blue: 0.7)],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        ),
                                                        lineWidth: 2
                                                    )
                                                    .frame(width: 44, height: 44)
                                            } else if day.hasWorkout {
                                                Circle()
                                                    .stroke(Color.green.opacity(0.5), lineWidth: 2)
                                                    .frame(width: 44, height: 44)
                                            } else {
                                                Circle()
                                                    .fill(Color.gray.opacity(0.1))
                                                    .frame(width: 44, height: 44)
                                            }

                                            Text("\(day.dayNumber)")
                                                .font(.system(.body, design: .rounded, weight: day.isSelected ? .bold : .regular))
                                                .foregroundStyle(day.isSelected ? .white : (day.isToday ? Color(red: 0.5, green: 0.8, blue: 0.5) : .primary))
                                        }

                                        // Workout indicator dot
                                        if day.hasWorkout {
                                            Circle()
                                                .fill(Color.green)
                                                .frame(width: 6, height: 6)
                                        } else {
                                            Circle()
                                                .fill(Color.clear)
                                                .frame(width: 6, height: 6)
                                        }
                                    }
                                    .frame(width: 60)
                                }
                                .buttonStyle(.plain)
                                .id(day.date)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .onChange(of: selectedDate) { _, newDate in
                    withAnimation {
                        proxy.scrollTo(newDate, anchor: .center)
                    }
                }
                .onAppear {
                    proxy.scrollTo(selectedDate, anchor: .center)
                }
            }
        }
    }

    // MARK: - Recent Activity
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.isFilteringByDate ? "Activity" : "Recent Activity")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    if viewModel.isFilteringByDate {
                        Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if viewModel.isFilteringByDate {
                    Button(action: {
                        selectedDate = Date()
                        viewModel.clearDateFilter()
                    }) {
                        Text("Show All")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
            }

            if viewModel.filteredWorkouts.isEmpty {
                // Empty state
                VStack(spacing: 12) {
                    Image(systemName: viewModel.isFilteringByDate ? "calendar.badge.exclamationmark" : "figure.walk")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)

                    Text(viewModel.isFilteringByDate ? "No workouts on this day" : "No recent workouts")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text(viewModel.isFilteringByDate ? "Select another date or start a workout" : "Start your first workout to see your progress")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(viewModel.filteredWorkouts) { workout in
                    Button(action: {
                        selectedWorkout = workout
                    }) {
                        RecentActivityCard(workout: workout)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Recent Activity Card
struct RecentActivityCard: View {
    let workout: WorkoutEntity

    private var workoutIcon: String {
        let exerciseCount = (workout.exercises as? Set<ExerciseEntity>)?.count ?? 0
        return exerciseCount > 0 ? "dumbbell.fill" : "figure.walk"
    }

    private var iconColor: Color {
        Color(red: 0.7, green: 0.9, blue: 0.4)
    }

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 56, height: 56)

                Circle()
                    .stroke(iconColor, lineWidth: 2)
                    .frame(width: 56, height: 56)

                Image(systemName: workoutIcon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Workout")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Stats
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(workout.totalSets)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text("sets")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
    }
}

// MARK: - Week Day Model
struct WeekDay: Identifiable {
    let id = UUID()
    let date: Date
    let dayName: String
    let dayNumber: Int
    let isToday: Bool
    let isSelected: Bool
    let hasWorkout: Bool
}

// MARK: - Week Model
struct CalendarWeek: Identifiable {
    let id = UUID()
    let days: [WeekDay]
}

// MARK: - Home View Model
class HomeViewModel: ObservableObject {
    @Published var recentWorkouts: [WorkoutEntity] = []
    @Published var filteredWorkouts: [WorkoutEntity] = []
    @Published var scrollableWeeks: [CalendarWeek] = []
    @Published var workoutDates: Set<Date> = []
    @Published var selectedDate = Date()
    @Published var isFilteringByDate = false

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        setupScrollableWeeks()
    }

    func loadData() {
        fetchRecentWorkouts()
        updateScrollableWeeks()
    }

    private func fetchRecentWorkouts() {
        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]

        do {
            recentWorkouts = try viewContext.fetch(fetchRequest)

            // Build set of dates with workouts
            let calendar = Calendar.current
            workoutDates = Set(recentWorkouts.map { workout in
                calendar.startOfDay(for: workout.date)
            })

            // Initialize filtered workouts (show recent by default)
            if !isFilteringByDate {
                filteredWorkouts = Array(recentWorkouts.prefix(5))
            }
        } catch {
            print("Error fetching recent workouts: \(error)")
            recentWorkouts = []
            filteredWorkouts = []
        }
    }

    private func setupScrollableWeeks() {
        let calendar = Calendar.current
        let today = Date()

        // Create weeks from 3 months ago to 3 months in the future
        guard let startDate = calendar.date(byAdding: .month, value: -3, to: today),
              let endDate = calendar.date(byAdding: .month, value: 3, to: today) else {
            return
        }

        var weeks: [CalendarWeek] = []
        var currentDate = calendar.dateInterval(of: .weekOfYear, for: startDate)?.start ?? startDate

        while currentDate <= endDate {
            let days = (0..<7).compactMap { dayOffset -> WeekDay? in
                guard let date = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) else {
                    return nil
                }

                let dayName = date.formatted(.dateTime.weekday(.narrow))
                let dayNumber = calendar.component(.day, from: date)
                let isToday = calendar.isDateInToday(date)
                let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)

                return WeekDay(
                    date: date,
                    dayName: dayName,
                    dayNumber: dayNumber,
                    isToday: isToday,
                    isSelected: isSelected,
                    hasWorkout: false
                )
            }

            if !days.isEmpty {
                weeks.append(CalendarWeek(days: days))
            }

            guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextWeek
        }

        scrollableWeeks = weeks
    }

    private func updateScrollableWeeks() {
        let calendar = Calendar.current

        // Update workout status for each day
        scrollableWeeks = scrollableWeeks.map { week in
            let updatedDays = week.days.map { day in
                let dayStart = calendar.startOfDay(for: day.date)
                let hasWorkout = workoutDates.contains(dayStart)
                let isSelected = calendar.isDate(day.date, inSameDayAs: selectedDate)

                return WeekDay(
                    date: day.date,
                    dayName: day.dayName,
                    dayNumber: day.dayNumber,
                    isToday: day.isToday,
                    isSelected: isSelected,
                    hasWorkout: hasWorkout
                )
            }
            return CalendarWeek(days: updatedDays)
        }
    }

    func updateForDate(_ date: Date) {
        selectedDate = date
        updateScrollableWeeks()
    }

    func scrollToDate(_ date: Date) {
        selectedDate = date
        updateScrollableWeeks()
    }

    func filterWorkoutsByDate(_ date: Date) {
        selectedDate = date
        isFilteringByDate = true

        let calendar = Calendar.current
        filteredWorkouts = recentWorkouts.filter { workout in
            calendar.isDate(workout.date, inSameDayAs: date)
        }

        updateScrollableWeeks()
    }

    func clearDateFilter() {
        isFilteringByDate = false
        filteredWorkouts = Array(recentWorkouts.prefix(5))
        updateScrollableWeeks()
    }
}

// MARK: - Full Calendar View
struct FullCalendarView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    let workoutDates: Set<Date>
    let onDateSelected: (Date) -> Void

    @State private var displayedMonth: Date = Date()

    private let calendar = Calendar.current
    private let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Month/Year selector
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }

                    Spacer()

                    Text(displayedMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.title3)
                        .fontWeight(.semibold)

                    Spacer()

                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal)

                // Days of week header
                HStack(spacing: 0) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)

                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                    ForEach(monthDays(), id: \.self) { date in
                        if let date = date {
                            CalendarDayCell(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                isToday: calendar.isDateInToday(date),
                                hasWorkout: workoutDates.contains(calendar.startOfDay(for: date)),
                                isCurrentMonth: calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
                            ) {
                                selectedDate = date
                                onDateSelected(date)
                            }
                        } else {
                            Color.clear
                                .frame(height: 50)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.vertical)
            .background(Color.white)
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Today") {
                        displayedMonth = Date()
                        selectedDate = Date()
                        onDateSelected(Date())
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func monthDays() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }

        var days: [Date?] = []
        var currentDate = monthFirstWeek.start

        // Generate dates for the grid (including leading/trailing days from other months)
        for _ in 0..<42 { // 6 weeks max
            days.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return days
    }

    private func previousMonth() {
        guard let newMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) else {
            return
        }
        displayedMonth = newMonth
    }

    private func nextMonth() {
        guard let newMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else {
            return
        }
        displayedMonth = newMonth
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasWorkout: Bool
    let isCurrentMonth: Bool
    let action: () -> Void

    private let calendar = Calendar.current

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.7, green: 0.9, blue: 0.4), Color(red: 0.4, green: 0.8, blue: 0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else if isToday {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color(red: 0.7, green: 0.9, blue: 0.4), Color(red: 0.4, green: 0.8, blue: 0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }

                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(
                            isSelected ? .white :
                            isCurrentMonth ? .primary : .secondary.opacity(0.5)
                        )
                }
                .frame(width: 40, height: 40)

                // Workout indicator
                if hasWorkout {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(context: PersistenceController.preview.container.viewContext)
}
