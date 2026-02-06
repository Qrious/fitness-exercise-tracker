import SwiftUI
import CoreData

struct WorkoutDetailView: View {
    @Environment(\.dismiss) var dismiss
    let workout: WorkoutEntity

    var body: some View {
        NavigationStack {
            ZStack {
                // Modern light background
                Color.lightBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DesignConstants.spacingLarge) {
                        // Summary Card
                        GlassCard(backgroundColor: .white) {
                            VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Day \(workout.dayNumber)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.darkText)

                                        Text(workout.date.formatted)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }

                                Divider()

                                HStack(spacing: DesignConstants.spacingXLarge) {
                                    StatisticView(
                                        value: "\(workout.exercisesArray.count)",
                                        label: "Exercises"
                                    )

                                    StatisticView(
                                        value: "\(workout.totalSets)",
                                        label: "Sets"
                                    )

                                    StatisticView(
                                        value: "\(Int(workout.totalVolume))",
                                        label: "Volume"
                                    )
                                }
                            }
                        }

                        // Exercises
                        ForEach(workout.exercisesArray, id: \.id) { exercise in
                            ExerciseDetailCard(exercise: exercise)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct StatisticView: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.darkText)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct ExerciseDetailCard: View {
    let exercise: ExerciseEntity

    var body: some View {
        GlassCard(backgroundColor: .white) {
            VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
                Text(exercise.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.darkText)

                if !exercise.setsArray.isEmpty {
                    VStack(spacing: DesignConstants.spacingSmall) {
                        ForEach(Array(exercise.setsArray.enumerated()), id: \.element.id) { index, set in
                            HStack {
                                Text("Set \(index + 1)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 60, alignment: .leading)

                                Spacer()

                                HStack(spacing: DesignConstants.spacingMedium) {
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(Int(set.weight))")
                                            .font(.headline)
                                        Text("kg")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(width: 60, alignment: .trailing)

                                    Text("×")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)

                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(set.reps)")
                                            .font(.headline)
                                        Text("reps")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(width: 60, alignment: .trailing)
                                }
                            }
                            .padding(.vertical, DesignConstants.spacingXSmall)

                            if index < exercise.setsArray.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WorkoutDetailView(workout: PersistenceController.preview.container.viewContext.registeredObjects.compactMap { $0 as? WorkoutEntity }.first!)
}
