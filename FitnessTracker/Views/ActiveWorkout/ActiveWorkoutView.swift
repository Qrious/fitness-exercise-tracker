import SwiftUI
import CoreData

struct ActiveWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: WorkoutViewModel
    @State private var showingAddExercise = false
    @State private var selectedExercise: ExerciseEntity?
    @State private var scrollOffset: CGFloat = 0
    @State private var showingFinishConfirmation = false
    let autoStart: Bool

    init(context: NSManagedObjectContext, autoStart: Bool = false) {
        _viewModel = StateObject(wrappedValue: WorkoutViewModel(context: context))
        self.autoStart = autoStart
    }

    var body: some View {
        ZStack {
            // Modern light background
            Color.white
                .ignoresSafeArea()

            if viewModel.isWorkoutActive {
                activeWorkoutContent
            } else {
                startWorkoutView
            }
        }
        .onAppear {
            if autoStart && !viewModel.isWorkoutActive {
                viewModel.startWorkout()
            }
        }
        .toolbar {
            if viewModel.isWorkoutActive {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingFinishConfirmation = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundStyle(.blue)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.finishWorkout()
                        dismiss()
                    }) {
                        Text("Finish")
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .alert("Finish Workout?", isPresented: $showingFinishConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Discard Workout", role: .destructive) {
                viewModel.cancelWorkout()
                dismiss()
            }
            Button("Finish & Save") {
                viewModel.finishWorkout()
                dismiss()
            }
        } message: {
            Text("Do you want to save this workout or discard it?")
        }
    }

    private var startWorkoutView: some View {
        VStack(spacing: DesignConstants.spacingXLarge) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.primaryBlue)

            Text("Ready to Work Out?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.darkText)

            Button(action: viewModel.startWorkout) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Workout")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, DesignConstants.spacingXLarge)
                .padding(.vertical, DesignConstants.spacingLarge)
            }
            .background(Color.primaryBlue)
            .cornerRadius(DesignConstants.cornerRadiusMedium)
            .buttonStyle(.plain)
            .controlSize(.large)
        }
    }

    private var activeWorkoutContent: some View {
        VStack(spacing: 0) {
            // Header
            GlassCard(backgroundColor: .white) {
                VStack(alignment: .leading, spacing: DesignConstants.spacingSmall) {
                    Text("Workout in Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.darkText)

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
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseSheet(viewModel: viewModel)
        }
        .sheet(item: $selectedExercise) { (exercise: ExerciseEntity) in
            AddSetSheet(exercise: exercise, viewModel: viewModel)
        }
    }
}

// MARK: - Add Exercise Sheet
struct AddExerciseSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var exerciseName = ""
    @State private var previousExercises: [String] = []
    @State private var searchText = ""

    var filteredExercises: [String] {
        if searchText.isEmpty {
            return previousExercises
        } else {
            return previousExercises.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                VStack(spacing: 12) {
                    TextField("Search or enter new exercise", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                        .padding(.horizontal)
                        .padding(.top)

                    if !searchText.isEmpty && !previousExercises.contains(searchText) {
                        Button(action: {
                            viewModel.addExercise(name: searchText)
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Add \"\(searchText)\" as new exercise")
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 8)

                Divider()

                // Previous exercises list
                if previousExercises.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text("No previous exercises")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Text("Enter a name above to create your first exercise")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                } else {
                    List {
                        Section {
                            ForEach(filteredExercises, id: \.self) { exercise in
                                Button(action: {
                                    viewModel.addExercise(name: exercise)
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "dumbbell.fill")
                                            .foregroundStyle(.blue)
                                            .frame(width: 24)

                                        Text(exercise)
                                            .foregroundStyle(.primary)

                                        Spacer()

                                        Image(systemName: "plus.circle")
                                            .foregroundStyle(.blue)
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Text(searchText.isEmpty ? "Previous Exercises" : "Matching Exercises")
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                loadPreviousExercises()
            }
        }
    }

    private func loadPreviousExercises() {
        let fetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()

        do {
            let exercises = try viewModel.viewContext.fetch(fetchRequest)
            // Get unique exercise names, sorted by frequency and recency
            let exerciseNames = exercises.map { $0.name }
            let uniqueNames = Array(Set(exerciseNames)).sorted { name1, name2 in
                let count1 = exerciseNames.filter { $0 == name1 }.count
                let count2 = exerciseNames.filter { $0 == name2 }.count
                return count1 > count2 // More frequently used exercises first
            }
            previousExercises = uniqueNames
        } catch {
            print("Error fetching previous exercises: \(error)")
            previousExercises = []
        }
    }
}

// MARK: - Add Set Sheet
struct AddSetSheet: View {
    @Environment(\.dismiss) var dismiss
    let exercise: ExerciseEntity
    @ObservedObject var viewModel: WorkoutViewModel

    @State private var weight: Double
    @State private var reps: Int
    @FocusState private var weightFieldFocused: Bool
    @FocusState private var repsFieldFocused: Bool

    init(exercise: ExerciseEntity, viewModel: WorkoutViewModel) {
        self.exercise = exercise
        self.viewModel = viewModel

        // Use first set from previous workout with this exercise, or defaults
        let (defaultWeight, defaultReps) = Self.getPreviousExerciseDefaults(
            exerciseName: exercise.name,
            context: viewModel.viewContext,
            currentWorkout: viewModel.currentWorkout
        )

        _weight = State(initialValue: defaultWeight)
        _reps = State(initialValue: defaultReps)
    }

    private static func getPreviousExerciseDefaults(
        exerciseName: String,
        context: NSManagedObjectContext,
        currentWorkout: WorkoutEntity?
    ) -> (weight: Double, reps: Int) {
        // Fetch previous workouts with this exercise (excluding current workout)
        let workoutFetch: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        workoutFetch.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]

        do {
            let workouts = try context.fetch(workoutFetch)

            // Find the most recent workout (not the current one) that has this exercise
            for workout in workouts {
                // Skip the current workout
                if let current = currentWorkout, workout.id == current.id {
                    continue
                }

                // Look for the exercise in this workout
                if let exercises = workout.exercises as? Set<ExerciseEntity>,
                   let matchingExercise = exercises.first(where: { $0.name == exerciseName }),
                   let firstSet = matchingExercise.setsArray.first {
                    return (weight: firstSet.weight, reps: Int(firstSet.reps))
                }
            }
        } catch {
            print("Error fetching previous exercise data: \(error)")
        }

        // No previous data found, return defaults
        return (weight: 20.0, reps: 10)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise") {
                    Text(exercise.name)
                        .font(.headline)
                }

                // Weight Section
                Section {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Weight")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }

                        HStack(spacing: 16) {
                            // Decrement button
                            Button(action: { if weight > 0 { weight = max(0, weight - 2.5) } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.plain)

                            // Weight display with text field
                            HStack(spacing: 4) {
                                TextField("0", value: $weight, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.center)
                                    .font(.system(.title, design: .rounded, weight: .semibold))
                                    .frame(width: 80)
                                    .focused($weightFieldFocused)

                                Text("kg")
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }

                            // Increment button
                            Button(action: { weight += 2.5 }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity)

                        // Quick add buttons
                        HStack(spacing: 8) {
                            QuickAddButton(value: "-5", color: .orange) {
                                weight = max(0, weight - 5)
                            }
                            QuickAddButton(value: "-2.5", color: .orange) {
                                weight = max(0, weight - 2.5)
                            }
                            QuickAddButton(value: "+2.5", color: .blue) {
                                weight += 2.5
                            }
                            QuickAddButton(value: "+5", color: .blue) {
                                weight += 5
                            }
                            QuickAddButton(value: "+10", color: .blue) {
                                weight += 10
                            }
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("")
                }

                // Reps Section
                Section {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Reps")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }

                        HStack(spacing: 16) {
                            // Decrement button
                            Button(action: { if reps > 0 { reps -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.plain)

                            // Reps display with text field
                            TextField("0", value: $reps, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .font(.system(.title, design: .rounded, weight: .semibold))
                                .frame(width: 80)
                                .focused($repsFieldFocused)

                            // Increment button
                            Button(action: { reps += 1 }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity)

                        // Quick add buttons
                        HStack(spacing: 8) {
                            QuickAddButton(value: "-5", color: .orange) {
                                reps = max(0, reps - 5)
                            }
                            QuickAddButton(value: "-1", color: .orange) {
                                reps = max(0, reps - 1)
                            }
                            QuickAddButton(value: "+1", color: .blue) {
                                reps += 1
                            }
                            QuickAddButton(value: "+5", color: .blue) {
                                reps += 5
                            }
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("")
                }

                Section {
                    Button("Add Set") {
                        viewModel.addSet(to: exercise, weight: weight, reps: Int16(reps))
                        dismiss()
                    }
                    .disabled(weight <= 0 || reps <= 0)
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                }
            }
            .navigationTitle("Add Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        weightFieldFocused = false
                        repsFieldFocused = false
                    }
                }
            }
        }
    }
}

// MARK: - Quick Add Button
struct QuickAddButton: View {
    let value: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ActiveWorkoutView(context: PersistenceController.preview.container.viewContext)
}
