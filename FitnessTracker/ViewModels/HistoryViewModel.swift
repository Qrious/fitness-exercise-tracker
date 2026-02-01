import Foundation
import CoreData
import Combine

class HistoryViewModel: ObservableObject {
    @Published var workouts: [WorkoutEntity] = []

    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchWorkouts()
    }

    func fetchWorkouts() {
        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]

        do {
            workouts = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching workouts: \(error)")
            workouts = []
        }
    }

    func deleteWorkout(_ workout: WorkoutEntity) {
        viewContext.delete(workout)
        saveContext()
        fetchWorkouts()
    }

    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
