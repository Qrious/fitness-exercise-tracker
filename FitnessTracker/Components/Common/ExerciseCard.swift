import SwiftUI

/// Card view for displaying an exercise with its sets
struct ExerciseCard: View {
    let exercise: ExerciseEntity
    let onAddSet: () -> Void
    let onRemoveSet: (WorkoutSetEntity) -> Void
    let onRemoveExercise: () -> Void

    var body: some View {
        GlassCard(backgroundColor: .white) {
            VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
                // Header
                HStack {
                    Text(exercise.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.darkText)

                    Spacer()

                    Button(action: onRemoveExercise) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }

                // Sets
                if !exercise.setsArray.isEmpty {
                    VStack(spacing: DesignConstants.spacingSmall) {
                        ForEach(Array(exercise.setsArray.enumerated()), id: \.element.id) { index, set in
                            SetRowView(
                                setNumber: index + 1,
                                weight: set.weight,
                                reps: set.reps
                            ) {
                                onRemoveSet(set)
                            }
                        }
                    }
                }

                // Add Set Button
                Button(action: onAddSet) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Set")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignConstants.spacingMedium)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.primaryBlue)
            }
        }
        .padding(.horizontal)
    }
}
