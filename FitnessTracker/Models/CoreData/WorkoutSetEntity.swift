import Foundation
import CoreData

@objc(WorkoutSetEntity)
public class WorkoutSetEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var weight: Double
    @NSManaged public var reps: Int16
    @NSManaged public var duration: TimeInterval
    @NSManaged public var completedAt: Date
    @NSManaged public var orderIndex: Int16
    @NSManaged public var exercise: ExerciseEntity?
    @NSManaged public var workout: WorkoutEntity?

    var volume: Double {
        return weight * Double(reps)
    }
}

// MARK: - Convenience Initializer
extension WorkoutSetEntity {
    convenience init(context: NSManagedObjectContext, weight: Double, reps: Int16, orderIndex: Int16) {
        self.init(context: context)
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.orderIndex = orderIndex
        self.completedAt = Date()
        self.duration = 0
    }
}
