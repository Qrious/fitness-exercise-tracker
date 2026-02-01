# Fitness Tracker - iOS Workout App

A native iOS workout tracking application built with SwiftUI and the Liquid Glass design language for iOS 18+.

## Features

- **Active Workout Tracking**: Start workouts, add exercises, log sets with weight and reps
- **Workout History**: View all past workouts with day numbering
- **Statistics & Charts**: Visualize progress with Swift Charts
- **Search**: Find exercises and workouts quickly
- **Liquid Glass Design**: Modern iOS 18 design with glass morphism effects

## Requirements

- iOS 18.0+
- Xcode 16+
- Swift 5.9+

## Project Structure

```
FitnessTracker/
├── FitnessTrackerApp.swift          # Main app entry point
├── Models/
│   └── CoreData/                     # Core Data stack and entities
├── ViewModels/                       # MVVM view models
├── Views/                            # SwiftUI views
│   ├── MainTabView.swift            # Main tab container
│   ├── ActiveWorkout/               # Workout tracking screens
│   ├── History/                     # Workout history
│   ├── Statistics/                  # Charts and stats
│   └── Search/                      # Search interface
├── Components/
│   ├── LiquidGlass/                 # Glass effect components
│   └── Common/                      # Reusable components
└── Utilities/                        # Extensions and constants
```

## Setup Instructions

### Option 1: Create Xcode Project Manually

1. Open Xcode 16+
2. Create a new **App** project:
   - Product Name: `FitnessTracker`
   - Interface: **SwiftUI**
   - Life Cycle: **SwiftUI App**
   - Language: **Swift**
   - Storage: **Core Data** (check this box)
   - Include Tests: Yes
3. Delete the default ContentView.swift file
4. Add all the files from the `FitnessTracker/` directory to your project
5. Ensure the Core Data model file is added to the target

### Option 2: Use Command Line (requires xcodeproj)

```bash
# Navigate to project directory
cd fitness-exercise-tracker

# The project files are ready in the FitnessTracker/ directory
# Open Xcode and drag the folder into a new project
```

## Building and Running

1. Open the project in Xcode
2. Select a simulator (iPhone 15 Pro or later recommended for iOS 18)
3. Press Cmd+R to build and run
4. The app will launch with the workout tab

## Core Features Usage

### Starting a Workout
1. Tap "Start Workout" on the Workout tab
2. Tap "Add Exercise" to add an exercise
3. Add sets with weight and reps
4. Tap "Finish Workout" when done

### Viewing History
1. Navigate to the History tab
2. See all completed workouts with day numbers
3. Tap any workout to view details

### Viewing Statistics
1. Navigate to the Stats tab
2. See overall statistics
3. Select an exercise to view progression charts
4. View personal records

### Searching
1. Navigate to the Search tab
2. Type an exercise name
3. Results show all workouts containing that exercise

## Design System

### Liquid Glass Components
- **LiquidGlassModifier**: Applies glass morphism effect
- **GlassCard**: Pre-built card component
- **DynamicTabBar**: Custom tab bar with dynamic height

### Design Tokens
See `Utilities/Constants.swift` for all design values:
- Corner radius: 12-20pt
- Spacing: 4-24pt
- Typography sizes
- Animation parameters

## Core Data Model

### Entities
- **WorkoutEntity**: Stores workout metadata and day number
- **ExerciseEntity**: Exercise within a workout
- **WorkoutSetEntity**: Individual set with weight/reps

### Relationships
- Workout → Exercises (one-to-many)
- Exercise → Sets (one-to-many)
- Set → Exercise (many-to-one)

## Accessibility

- VoiceOver support for all interactive elements
- Dynamic Type support
- Reduce Transparency fallback (opaque backgrounds)
- Reduce Motion support
- 4.5:1 minimum contrast ratio

## Testing

### Manual Test Flow
1. Launch app in iOS 18 simulator
2. Create a workout with 2-3 exercises
3. Add 3 sets to each exercise
4. Complete the workout
5. Verify it appears in History as "Day 1"
6. Create another workout, verify "Day 2"
7. Check Statistics tab for charts
8. Test search functionality
9. Toggle Dark Mode
10. Enable Reduce Transparency in Settings > Accessibility

## Future Enhancements

- [ ] Workout templates
- [ ] Exercise library with images
- [ ] Rest timer between sets
- [ ] Export workout data
- [ ] iCloud sync
- [ ] Apple Watch companion app
- [ ] Workout notes and photos

## License

This project is for educational purposes.

## Version

1.0 - Initial Release
