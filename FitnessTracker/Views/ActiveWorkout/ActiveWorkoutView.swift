import SwiftUI

struct ActiveWorkoutView: View {
    @StateObject private var viewModel: WorkoutViewModel
    @State private var showingAddExercise = false
    @State private var showingAddSet = false
    @State private var selectedExercise: ExerciseEntity?
    @State private var scrollOffset: CGFloat = 0

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: WorkoutViewModel(context: context))
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if viewModel.isWorkoutActive {
                activeWorkoutContent
            } else {
                startWorkoutView
            }
        }
    }

    private var startWorkoutView: some View {
        VStack(spacing: DesignConstants.spacingXLarge) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 64))
                .foregroundStyle(.blue)

            Text("Ready to Work Out?")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button(action: viewModel.startWorkout) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Workout")
                }
                .font(.headline)
                .padding(.horizontal, DesignConstants.spacingXLarge)
                .padding(.vertical, DesignConstants.spacingLarge)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    private var activeWorkoutContent: some View {
        VStack(spacing: 0) {
            // Header
            GlassCard {
                VStack(alignment: .leading, spacing: DesignConstants.spacingSmall) {
                    Text("Workout in Progress")
                        .font(.title2)
                        .fontWeight(.bold)

                    if let workout = viewModel.currentWorkout {
                        Text("Day \(workout.dayNumber)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top)

            // Exercises
            ScrollView {
                LazyVStack(spacing: DesignConstants.spacingLarge) {
                    ForEach(viewModel.exercises, id: \.id) { exercise in
                        ExerciseCard(
                            exercise: exercise,
                            onAddSet: {
                                selectedExercise = exercise
                                showingAddSet = true
                            },
                            onRemoveSet: { set in
                                viewModel.removeSet(set, from: exercise)
                            },
                            onRemoveExercise: {
                                viewModel.removeExercise(exercise)
                            }
                        )
                    }

                    // Add Exercise Button
                    Button(action: { showingAddExercise = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Exercise")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignConstants.spacingLarge)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }

            // Bottom Actions
            HStack(spacing: DesignConstants.spacingMedium) {
                Button("Cancel", role: .cancel) {
                    viewModel.cancelWorkout()
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button("Finish Workout") {
                    viewModel.finishWorkout()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.exercises.isEmpty)
            }
            .padding()
            .liquidGlass(cornerRadius: 0, addGlow: false)
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddSet) {
            if let exercise = selectedExercise {
                AddSetSheet(exercise: exercise, viewModel: viewModel)
            }
        }
    }
}

// MARK: - Add Exercise Sheet
struct AddExerciseSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var exerciseName = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Exercise Name", text: $exerciseName)
                        .textInputAutocapitalization(.words)
                }

                Section {
                    Button("Add Exercise") {
                        viewModel.addExercise(name: exerciseName)
                        dismiss()
                    }
                    .disabled(exerciseName.isEmpty)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Add Set Sheet
struct AddSetSheet: View {
    @Environment(\.dismiss) var dismiss
    let exercise: ExerciseEntity
    @ObservedObject var viewModel: WorkoutViewModel

    @State private var weight: String = ""
    @State private var reps: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise") {
                    Text(exercise.name)
                        .font(.headline)
                }

                Section {
                    HStack {
                        Text("Weight (lbs)")
                        Spacer()
                        TextField("0", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }

                    HStack {
                        Text("Reps")
                        Spacer()
                        TextField("0", text: $reps)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }

                Section {
                    Button("Add Set") {
                        if let weightValue = Double(weight),
                           let repsValue = Int16(reps) {
                            viewModel.addSet(to: exercise, weight: weightValue, reps: repsValue)
                            dismiss()
                        }
                    }
                    .disabled(weight.isEmpty || reps.isEmpty)
                }
            }
            .navigationTitle("Add Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ActiveWorkoutView(context: PersistenceController.preview.container.viewContext)
}
