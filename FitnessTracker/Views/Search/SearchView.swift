import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    @State private var selectedWorkout: WorkoutEntity?

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.green.opacity(0.3), .teal.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with Search
                GlassCard {
                    VStack(spacing: DesignConstants.spacingMedium) {
                        Text("Search")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)

                            TextField("Search exercises or workouts...", text: $searchText)
                                .textFieldStyle(.plain)
                                .onChange(of: searchText) { _, newValue in
                                    performSearch(query: newValue)
                                }

                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(DesignConstants.spacingMedium)
                        .background(.regularMaterial)
                        .cornerRadius(DesignConstants.cornerRadiusSmall)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                if searchText.isEmpty {
                    emptySearchView
                } else if searchResults.isEmpty {
                    noResultsView
                } else {
                    searchResultsList
                }
            }
        }
        .sheet(item: $selectedWorkout) { workout in
            WorkoutDetailView(workout: workout)
        }
    }

    private var emptySearchView: some View {
        VStack(spacing: DesignConstants.spacingLarge) {
            Image(systemName: "text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("Search Your Workouts")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Find exercises and workouts by name")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }

    private var noResultsView: some View {
        VStack(spacing: DesignConstants.spacingLarge) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("No Results Found")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Try a different search term")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }

    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: DesignConstants.spacingLarge) {
                ForEach(searchResults) { result in
                    SearchResultCard(result: result) {
                        selectedWorkout = result.workout
                    }
                }
            }
            .padding()
        }
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)]

        do {
            let workouts = try viewContext.fetch(fetchRequest)
            var results: [SearchResult] = []

            for workout in workouts {
                for exercise in workout.exercisesArray {
                    if exercise.name.localizedCaseInsensitiveContains(query) {
                        results.append(SearchResult(
                            workout: workout,
                            exercise: exercise,
                            matchType: .exercise
                        ))
                    }
                }
            }

            searchResults = results
        } catch {
            print("Search error: \(error)")
            searchResults = []
        }
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let workout: WorkoutEntity
    let exercise: ExerciseEntity
    let matchType: MatchType

    enum MatchType {
        case exercise
        case workout
    }
}

struct SearchResultCard: View {
    let result: SearchResult
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            GlassCard {
                VStack(alignment: .leading, spacing: DesignConstants.spacingMedium) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.exercise.name)
                                .font(.headline)
                                .fontWeight(.semibold)

                            Text("Day \(result.workout.dayNumber) • \(result.workout.date.historyFormatted)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }

                    if !result.exercise.setsArray.isEmpty {
                        HStack(spacing: DesignConstants.spacingLarge) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(result.exercise.setsArray.count)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text("Sets")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            if let maxWeight = result.exercise.setsArray.map({ $0.weight }).max() {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(Int(maxWeight))")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text("Max Weight")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SearchView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
