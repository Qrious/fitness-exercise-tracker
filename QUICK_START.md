# Quick Start Guide

## Fastest Way to Get Running

### 1. Open Xcode and Create Project
```bash
# From terminal, open Xcode
open -a Xcode
```

Then in Xcode:
- File → New → Project
- iOS → App
- Name: **FitnessTracker**
- Interface: **SwiftUI**
- Language: **Swift**
- Storage: **Core Data** ✓
- Save in: `/Users/sander/src/fitness-exercise-tracker/`

### 2. Add Files
- Delete default `ContentView.swift`
- Drag entire `FitnessTracker/` folder into project
- Check "Copy items if needed" and "Create groups"

### 3. Run
- Select iPhone 15 Pro simulator
- Press Cmd+R

## That's It!

The app should launch with the workout tracker interface.

## First Test
1. Tap "Start Workout"
2. Tap "Add Exercise"
3. Enter "Bench Press"
4. Tap "Add Set"
5. Enter weight: 135, reps: 10
6. Tap "Finish Workout"
7. Switch to History tab to see "Day 1"

## File Count
You should have approximately **30 files** in the project:
- 1 main app file
- 7 Core Data files
- 3 ViewModels
- 10 View files
- 5 Component files
- 2 Utility files
- 1 Info.plist
- Assets

## Key Features to Test
- ✅ Start/finish workouts
- ✅ Add exercises and sets
- ✅ View history with day numbers
- ✅ Charts in Statistics tab
- ✅ Search exercises
- ✅ Dark mode toggle
- ✅ Glass UI effects

## Troubleshooting

**Build fails?**
→ Clean Build Folder (Cmd+Shift+K)

**Core Data error?**
→ Check FitnessTracker.xcdatamodeld is in target

**Files not found?**
→ Verify all .swift files in Build Phases → Compile Sources

See `setup-project.md` for detailed instructions.
