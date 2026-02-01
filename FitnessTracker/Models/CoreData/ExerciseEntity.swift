import Foundation
import CoreData

@objc(ExerciseEntity)
public class ExerciseEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var sets: NSSet?
    @NSManaged public var workout: WorkoutEntity?

    var setsArray: [WorkoutSetEntity] {
        let set = sets as? Set<WorkoutSetEntity> ?? []
        return set.sorted { $0.orderIndex < $1.orderIndex }
    }
}

// MARK: - Convenience Initializer
extension ExerciseEntity {
    convenience init(context: NSManagedObjectContext, name: String) {
        self.init(context: context)
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}

// MARK: - Core Data Generated accessors
extension ExerciseEntity {
    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: WorkoutSetEntity)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: WorkoutSetEntity)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)
}
