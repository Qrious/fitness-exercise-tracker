# Xcode Project Setup Guide

Since we cannot programmatically create a complete `.xcodeproj` file, follow these steps to set up the project in Xcode:

## Step-by-Step Setup

### 1. Create New Project
1. Open Xcode 16+
2. Select **File → New → Project**
3. Choose **iOS → App**
4. Click **Next**

### 2. Configure Project Settings
- **Product Name**: `FitnessTracker`
- **Team**: Select your team or leave as None
- **Organization Identifier**: `com.yourname` (or your preference)
- **Bundle Identifier**: Will auto-generate as `com.yourname.FitnessTracker`
- **Interface**: **SwiftUI**
- **Language**: **Swift**
- **Storage**: **Core Data** ✓ (CHECK THIS BOX)
- **Include Tests**: ✓ (CHECK THIS BOX)
- Click **Next**

### 3. Save Location
- Navigate to: `/Users/sander/src/fitness-exercise-tracker/`
- Click **Create**

### 4. Remove Default Files
Xcode will create some default files. Delete these:
- `ContentView.swift`
- The default `FitnessTracker.xcdatamodeld` if it was created

### 5. Add Project Files

#### Method A: Drag and Drop
1. In Finder, open `/Users/sander/src/fitness-exercise-tracker/FitnessTracker/`
2. Select all folders and files
3. Drag them into the Xcode project navigator
4. In the dialog that appears:
   - ✓ Check "Copy items if needed"
   - ✓ Check "Create groups"
   - ✓ Add to target: FitnessTracker
5. Click **Finish**

#### Method B: Add Files Manually
1. Right-click the `FitnessTracker` group in Xcode
2. Select **Add Files to "FitnessTracker"...**
3. Navigate to the `FitnessTracker/` folder
4. Select all files and folders
5. Ensure options:
   - ✓ Copy items if needed
   - ✓ Create groups
   - ✓ Add to target: FitnessTracker
6. Click **Add**

### 6. Verify File Structure
Your Xcode navigator should look like this:
```
FitnessTracker
├── FitnessTrackerApp.swift
├── Models
│   └── CoreData
│       ├── ExerciseEntity.swift
│       ├── WorkoutSetEntity.swift
│       ├── WorkoutEntity.swift
│       ├── PersistenceController.swift
│       └── FitnessTracker.xcdatamodeld
├── ViewModels
│   ├── WorkoutViewModel.swift
│   ├── HistoryViewModel.swift
│   └── StatisticsViewModel.swift
├── Views
│   ├── MainTabView.swift
│   ├── ActiveWorkout
│   ├── History
│   ├── Statistics
│   └── Search
├── Components
│   ├── LiquidGlass
│   └── Common
├── Utilities
│   ├── Constants.swift
│   └── Extensions.swift
├── Info.plist
└── Resources
```

### 7. Configure Build Settings
1. Select the project in the navigator
2. Select the **FitnessTracker** target
3. Go to **General** tab:
   - **Minimum Deployments**: Set to **iOS 18.0**
4. Go to **Signing & Capabilities**:
   - Select your team or enable "Automatically manage signing"

### 8. Verify Core Data Model
1. Click on `FitnessTracker.xcdatamodeld` in the navigator
2. You should see three entities:
   - ExerciseEntity
   - WorkoutEntity
   - WorkoutSetEntity
3. If not visible, the model may not have loaded correctly. Try:
   - Clean Build Folder (Cmd+Shift+K)
   - Restart Xcode

### 9. Build the Project
1. Select a simulator: **iPhone 15 Pro** (or any iOS 18+ device)
2. Press **Cmd+B** to build
3. Fix any compilation errors if they appear
   - Most common: Missing imports or incorrect file references

### 10. Run the App
1. Press **Cmd+R** to run
2. The app should launch in the simulator
3. You should see the "Ready to Work Out?" screen

## Common Issues and Fixes

### Issue: Core Data Model Not Found
**Error**: `Failed to load model named FitnessTracker`

**Fix**:
1. Select `FitnessTracker.xcdatamodeld` in navigator
2. Open File Inspector (Cmd+Opt+1)
3. Verify **Target Membership** includes FitnessTracker
4. Clean and rebuild

### Issue: Files Not Compiling
**Error**: Various compilation errors

**Fix**:
1. Check that all files are added to the FitnessTracker target
2. Open Build Phases → Compile Sources
3. Ensure all `.swift` files are listed
4. If missing, add them manually

### Issue: Simulator Won't Run
**Error**: iOS 18 not available

**Fix**:
1. Go to **Xcode → Settings → Platforms**
2. Download iOS 18 Simulator
3. Restart Xcode
4. Select the iOS 18 simulator

### Issue: App Icon Missing
**Note**: This is expected - we haven't created the app icon yet

**Optional Fix**:
1. Create an icon using SF Symbols or design tool
2. Add to `Assets.xcassets/AppIcon.appiconset`
3. Recommended: 1024x1024 master icon

## Verification Checklist

Before running, verify:
- [ ] All Swift files compile without errors
- [ ] Core Data model is visible and has 3 entities
- [ ] Minimum deployment target is iOS 18.0
- [ ] Simulator is iOS 18+
- [ ] FitnessTrackerApp.swift is set as the app entry point

## Next Steps

Once the app runs successfully:
1. Test the workout flow
2. Create sample workouts
3. Verify data persistence
4. Test all four tabs
5. Toggle Dark Mode
6. Test accessibility features

## Additional Resources

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Data Programming Guide](https://developer.apple.com/documentation/coredata)
- [Swift Charts Documentation](https://developer.apple.com/documentation/charts)

## Support

If you encounter issues:
1. Clean Build Folder (Cmd+Shift+K)
2. Delete Derived Data
3. Restart Xcode
4. Check the README.md for additional context
