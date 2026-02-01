import Foundation
import CoreData

@objc(WorkoutEntity)
public class WorkoutEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var dayNumber: Int32
    @NSManaged public var notes: String?
    @NSManaged public var exercises: NSSet?

    var exercisesArray: [ExerciseEntity] {
        let set = exercises as? Set<ExerciseEntity> ?? []
        return set.sorted { $0.createdAt < $1.createdAt }
    }

    var totalVolume: Double {
        exercisesArray.reduce(0) { total, exercise in
            total + exercise.setsArray.reduce(0) { $0 + $1.volume }
        }
    }

    var totalSets: Int {
        exercisesArray.reduce(0) { total, exercise in
            total + exercise.setsArray.count
        }
    }
}

// MARK: - Convenience Initializer
extension WorkoutEntity {
    convenience init(context: NSManagedObjectContext, dayNumber: Int32 = 0) {
        self.init(context: context)
        self.id = UUID()
        self.date = Date()
        self.dayNumber = dayNumber
    }

    /// Calculate day number based on first workout date
    func calculateDayNumber(firstWorkoutDate: Date) {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: firstWorkoutDate, to: date).day ?? 0
        self.dayNumber = Int32(days + 1)
    }
}

// MARK: - Core Data Generated accessors
extension WorkoutEntity {
    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)
}
