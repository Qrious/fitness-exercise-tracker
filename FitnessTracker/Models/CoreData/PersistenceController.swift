import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Create the managed object model programmatically
        let model = NSManagedObjectModel()

        // WorkoutEntity
        let workoutEntity = NSEntityDescription()
        workoutEntity.name = "WorkoutEntity"
        workoutEntity.managedObjectClassName = "WorkoutEntity"

        var workoutProperties = [NSAttributeDescription]()

        let workoutId = NSAttributeDescription()
        workoutId.name = "id"
        workoutId.attributeType = .UUIDAttributeType
        workoutId.isOptional = false
        workoutProperties.append(workoutId)

        let workoutDate = NSAttributeDescription()
        workoutDate.name = "date"
        workoutDate.attributeType = .dateAttributeType
        workoutDate.isOptional = false
        workoutProperties.append(workoutDate)

        let workoutDayNumber = NSAttributeDescription()
        workoutDayNumber.name = "dayNumber"
        workoutDayNumber.attributeType = .integer32AttributeType
        workoutDayNumber.defaultValue = 0
        workoutDayNumber.isOptional = false
        workoutProperties.append(workoutDayNumber)

        let workoutNotes = NSAttributeDescription()
        workoutNotes.name = "notes"
        workoutNotes.attributeType = .stringAttributeType
        workoutNotes.isOptional = true
        workoutProperties.append(workoutNotes)

        // ExerciseEntity
        let exerciseEntity = NSEntityDescription()
        exerciseEntity.name = "ExerciseEntity"
        exerciseEntity.managedObjectClassName = "ExerciseEntity"

        var exerciseProperties = [NSAttributeDescription]()

        let exerciseId = NSAttributeDescription()
        exerciseId.name = "id"
        exerciseId.attributeType = .UUIDAttributeType
        exerciseId.isOptional = false
        exerciseProperties.append(exerciseId)

        let exerciseName = NSAttributeDescription()
        exerciseName.name = "name"
        exerciseName.attributeType = .stringAttributeType
        exerciseName.isOptional = false
        exerciseProperties.append(exerciseName)

        let exerciseCreatedAt = NSAttributeDescription()
        exerciseCreatedAt.name = "createdAt"
        exerciseCreatedAt.attributeType = .dateAttributeType
        exerciseCreatedAt.isOptional = false
        exerciseProperties.append(exerciseCreatedAt)

        let exerciseNotes = NSAttributeDescription()
        exerciseNotes.name = "notes"
        exerciseNotes.attributeType = .stringAttributeType
        exerciseNotes.isOptional = true
        exerciseProperties.append(exerciseNotes)

        // WorkoutSetEntity
        let setEntity = NSEntityDescription()
        setEntity.name = "WorkoutSetEntity"
        setEntity.managedObjectClassName = "WorkoutSetEntity"

        var setProperties = [NSAttributeDescription]()

        let setId = NSAttributeDescription()
        setId.name = "id"
        setId.attributeType = .UUIDAttributeType
        setId.isOptional = false
        setProperties.append(setId)

        let setWeight = NSAttributeDescription()
        setWeight.name = "weight"
        setWeight.attributeType = .doubleAttributeType
        setWeight.defaultValue = 0.0
        setWeight.isOptional = false
        setProperties.append(setWeight)

        let setReps = NSAttributeDescription()
        setReps.name = "reps"
        setReps.attributeType = .integer16AttributeType
        setReps.defaultValue = 0
        setReps.isOptional = false
        setProperties.append(setReps)

        let setOrderIndex = NSAttributeDescription()
        setOrderIndex.name = "orderIndex"
        setOrderIndex.attributeType = .integer16AttributeType
        setOrderIndex.defaultValue = 0
        setOrderIndex.isOptional = false
        setProperties.append(setOrderIndex)

        let setDuration = NSAttributeDescription()
        setDuration.name = "duration"
        setDuration.attributeType = .doubleAttributeType
        setDuration.defaultValue = 0.0
        setDuration.isOptional = false
        setProperties.append(setDuration)

        let setCompletedAt = NSAttributeDescription()
        setCompletedAt.name = "completedAt"
        setCompletedAt.attributeType = .dateAttributeType
        setCompletedAt.isOptional = false
        setProperties.append(setCompletedAt)

        // Relationships
        let workoutExercisesRel = NSRelationshipDescription()
        workoutExercisesRel.name = "exercises"
        workoutExercisesRel.destinationEntity = exerciseEntity
        workoutExercisesRel.isOptional = true
        workoutExercisesRel.maxCount = 0 // to-many
        workoutExercisesRel.deleteRule = .cascadeDeleteRule

        let exerciseWorkoutRel = NSRelationshipDescription()
        exerciseWorkoutRel.name = "workout"
        exerciseWorkoutRel.destinationEntity = workoutEntity
        exerciseWorkoutRel.isOptional = true
        exerciseWorkoutRel.maxCount = 1 // to-one
        exerciseWorkoutRel.deleteRule = .nullifyDeleteRule

        workoutExercisesRel.inverseRelationship = exerciseWorkoutRel
        exerciseWorkoutRel.inverseRelationship = workoutExercisesRel

        let exerciseSetsRel = NSRelationshipDescription()
        exerciseSetsRel.name = "sets"
        exerciseSetsRel.destinationEntity = setEntity
        exerciseSetsRel.isOptional = true
        exerciseSetsRel.maxCount = 0 // to-many
        exerciseSetsRel.deleteRule = .cascadeDeleteRule

        let setExerciseRel = NSRelationshipDescription()
        setExerciseRel.name = "exercise"
        setExerciseRel.destinationEntity = exerciseEntity
        setExerciseRel.isOptional = true
        setExerciseRel.maxCount = 1 // to-one
        setExerciseRel.deleteRule = .nullifyDeleteRule

        exerciseSetsRel.inverseRelationship = setExerciseRel
        setExerciseRel.inverseRelationship = exerciseSetsRel

        let setWorkoutRel = NSRelationshipDescription()
        setWorkoutRel.name = "workout"
        setWorkoutRel.destinationEntity = workoutEntity
        setWorkoutRel.isOptional = true
        setWorkoutRel.maxCount = 1 // to-one
        setWorkoutRel.deleteRule = .nullifyDeleteRule

        // Set properties and relationships
        workoutEntity.properties = workoutProperties + [workoutExercisesRel]
        exerciseEntity.properties = exerciseProperties + [exerciseWorkoutRel, exerciseSetsRel]
        setEntity.properties = setProperties + [setExerciseRel, setWorkoutRel]

        model.entities = [workoutEntity, exerciseEntity, setEntity]

        container = NSPersistentContainer(name: "FitnessTracker", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    /// Create a preview instance for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Create sample data
        let workout = WorkoutEntity(context: viewContext)
        workout.id = UUID()
        workout.date = Date()
        workout.notes = "Sample workout"

        let exercise = ExerciseEntity(context: viewContext)
        exercise.id = UUID()
        exercise.name = "Bench Press"
        exercise.createdAt = Date()
        exercise.workout = workout

        let set = WorkoutSetEntity(context: viewContext)
        set.id = UUID()
        set.weight = 135
        set.reps = 10
        set.completedAt = Date()
        set.orderIndex = 0
        set.exercise = exercise
        set.workout = workout

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    /// Save context if it has changes
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
