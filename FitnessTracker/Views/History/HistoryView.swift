import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    @State private var selectedWorkout: WorkoutEntity?

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(context: context))
    }

    var body: some View {
        ZStack {
            // Modern light background
            Color.lightBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                GlassCard(backgroundColor: .white) {
                    Text("Workout History")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.darkText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.top)

                if viewModel.workouts.isEmpty {
                    emptyStateView
                } else {
                    workoutsList
                }
            }
        }
        .onAppear {
            viewModel.fetchWorkouts()
        }
        .sheet(item: $selectedWorkout) { workout in
            WorkoutDetailView(workout: workout)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: DesignConstants.spacingLarge) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("No Workouts Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Complete your first workout to see it here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }

    private var workoutsList: some View {
        ScrollView {
            LazyVStack(spacing: DesignConstants.spacingLarge) {
                ForEach(viewModel.workouts, id: \.id) { workout in
                    WorkoutHistoryCard(workout: workout) {
                        selectedWorkout = workout
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
        }
    }
}

struct WorkoutHistoryCard: View {
    let workout: WorkoutEntity
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            GlassCard(backgroundColor: .white) {
                VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Day \(workout.dayNumber)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.darkText)

                            Text(workout.date.historyFormatted)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: DesignConstants.spacingXLarge) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(workout.exercisesArray.count)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.darkText)
                            Text("Exercises")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(workout.totalSets)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.darkText)
                            Text("Sets")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(Int(workout.totalVolume))")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.darkText)
                            Text("Volume")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HistoryView(context: PersistenceController.preview.container.viewContext)
}
