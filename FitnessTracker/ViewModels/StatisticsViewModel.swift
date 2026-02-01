import Foundation
import CoreData
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var workouts: [WorkoutEntity] = []
    @Published var exerciseNames: [String] = []
    @Published var selectedExercise: String?

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchData()
    }

    func fetchData() {
        // Fetch all workouts
        let workoutFetch: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        workoutFetch.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]

        do {
            workouts = try viewContext.fetch(workoutFetch)
        } catch {
            print("Error fetching workouts: \(error)")
            workouts = []
        }

        // Get unique exercise names
        let exerciseFetch: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        do {
            let exercises = try viewContext.fetch(exerciseFetch)
            exerciseNames = Array(Set(exercises.map { $0.name })).sorted()
            if selectedExercise == nil {
                selectedExercise = exerciseNames.first
            }
        } catch {
            print("Error fetching exercises: \(error)")
            exerciseNames = []
        }
    }

    // MARK: - Statistics Calculations

    var totalWorkouts: Int {
        workouts.count
    }

    var totalVolume: Double {
        workouts.reduce(0) { $0 + $1.totalVolume }
    }

    var totalSets: Int {
        workouts.reduce(0) { $0 + $1.totalSets }
    }

    func maxWeightForExercise(_ exerciseName: String) -> Double {
        var maxWeight: Double = 0

        for workout in workouts {
            for exercise in workout.exercisesArray where exercise.name == exerciseName {
                for set in exercise.setsArray {
                    maxWeight = max(maxWeight, set.weight)
                }
            }
        }

        return maxWeight
    }

    func progressionDataForExercise(_ exerciseName: String) -> [ProgressDataPoint] {
        var dataPoints: [ProgressDataPoint] = []

        for workout in workouts {
            for exercise in workout.exercisesArray where exercise.name == exerciseName {
                // Calculate average weight for this exercise in this workout
                let sets = exercise.setsArray
                guard !sets.isEmpty else { continue }

                let avgWeight = sets.reduce(0.0) { $0 + $1.weight } / Double(sets.count)
                let totalVolume = sets.reduce(0.0) { $0 + $1.volume }

                dataPoints.append(ProgressDataPoint(
                    date: workout.date,
                    dayNumber: Int(workout.dayNumber),
                    averageWeight: avgWeight,
                    maxWeight: sets.map { $0.weight }.max() ?? 0,
                    totalVolume: totalVolume
                ))
            }
        }

        return dataPoints
    }

    func volumeOverTime() -> [VolumeDataPoint] {
        workouts.map { workout in
            VolumeDataPoint(
                date: workout.date,
                dayNumber: Int(workout.dayNumber),
                volume: workout.totalVolume
            )
        }
    }
}

struct ProgressDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let dayNumber: Int
    let averageWeight: Double
    let maxWeight: Double
    let totalVolume: Double
}

struct VolumeDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let dayNumber: Int
    let volume: Double
}
