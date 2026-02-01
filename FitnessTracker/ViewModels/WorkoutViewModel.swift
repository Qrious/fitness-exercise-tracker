import Foundation
import CoreData
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var currentWorkout: WorkoutEntity?
    @Published var exercises: [ExerciseEntity] = []
    @Published var isWorkoutActive = false

    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    // MARK: - Workout Management

    func startWorkout() {
        guard currentWorkout == nil else { return }

        let workout = WorkoutEntity(context: viewContext)
        workout.date = Date()

        // Calculate day number
        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]
        fetchRequest.fetchLimit = 1

        if let firstWorkout = try? viewContext.fetch(fetchRequest).first {
            workout.calculateDayNumber(firstWorkoutDate: firstWorkout.date)
        } else {
            workout.dayNumber = 1
        }

        currentWorkout = workout
        exercises = []
        isWorkoutActive = true
    }

    func finishWorkout() {
        guard let workout = currentWorkout else { return }

        if exercises.isEmpty {
            viewContext.delete(workout)
        } else {
            saveContext()
        }

        currentWorkout = nil
        exercises = []
        isWorkoutActive = false
    }

    func cancelWorkout() {
        if let workout = currentWorkout {
            viewContext.delete(workout)
        }
        currentWorkout = nil
        exercises = []
        isWorkoutActive = false
    }

    // MARK: - Exercise Management

    func addExercise(name: String) {
        guard let workout = currentWorkout else { return }

        let exercise = ExerciseEntity(context: viewContext, name: name)
        exercise.workout = workout
        exercises.append(exercise)
        saveContext()
    }

    func removeExercise(_ exercise: ExerciseEntity) {
        guard let workout = currentWorkout else { return }
        workout.removeFromExercises(exercise)
        exercises.removeAll { $0.id == exercise.id }
        viewContext.delete(exercise)
        saveContext()
    }

    // MARK: - Set Management

    func addSet(to exercise: ExerciseEntity, weight: Double, reps: Int16) {
        guard let workout = currentWorkout else { return }

        let orderIndex = Int16(exercise.setsArray.count)
        let set = WorkoutSetEntity(context: viewContext, weight: weight, reps: reps, orderIndex: orderIndex)
        set.exercise = exercise
        set.workout = workout
        exercise.addToSets(set)

        saveContext()
        objectWillChange.send()
    }

    func removeSet(_ set: WorkoutSetEntity, from exercise: ExerciseEntity) {
        exercise.removeFromSets(set)
        viewContext.delete(set)

        // Reorder remaining sets
        for (index, remainingSet) in exercise.setsArray.enumerated() {
            remainingSet.orderIndex = Int16(index)
        }

        saveContext()
        objectWillChange.send()
    }

    func updateSet(_ set: WorkoutSetEntity, weight: Double, reps: Int16) {
        set.weight = weight
        set.reps = reps
        set.completedAt = Date()
        saveContext()
        objectWillChange.send()
    }

    // MARK: - Persistence

    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving workout: \(error)")
            }
        }
    }
}
