# SoloShuttle Comprehensive QA Audit Report

**Role:** QA Lead / Google Play Review Specialist
**Date:** July 2026

## 8. Play Store Readiness Score: 85/100
SoloShuttle is extremely close to production but requires critical compliance and performance fixes before it can be submitted to Google Play.

---

## 9. Priority Order for Fixing Issues
1. **[P0]** Add Privacy Policy Link (Settings Screen)
2. **[P1]** Refactor Session Timer (`setState` performance bottleneck)
3. **[P1]** Add `try/catch` to `StorageService` for OS restrictions
4. **[P1]** Display `completionCriteria` in UI (BWF Compliance)
5. **[P2]** Implement TTS Fallback / Error Handling
6. **[P2]** Compress Avatar Image Assets
7. **[P2]** Add empty states for unfinished modules
8. **[P2]** Add customizable rest durations

---

## 1. Critical Issues (P0 – Must Fix Before Release)
*   **Privacy Policy Missing:** Health and fitness apps require an explicit Privacy Policy link within the app (e.g., Settings screen) to pass Google Play Review. Currently absent.
*   **Play Store Metadata:** While `flutter_launcher_icons` is configured, it must be verified that `flutter pub run flutter_launcher_icons` was successfully executed to replace the default Flutter icon across all Android densities.

## 2. Major Issues (P1 – Important)
*   **Logic Bug / Storage Issue:** `SharedPreferencesStorageService.init()` does not wrap `SharedPreferences.getInstance()` in a `try-catch` block. On older Android devices with full storage or aggressive OS sandboxing, this will throw a `PlatformException` causing an unhandled white-screen crash on startup.
*   **Performance Issue:** `PremiumTrainingSessionScreen` uses `setState()` inside a `Timer.periodic` every 1 second (Lines 164-190). This triggers a complete widget tree rebuild of the complex premium screen every second, causing frame drops and battery drain.
*   **Coaching UI Bug:** While Phase 4 successfully added `progression` and `completionCriteria` to the `Drill` data model (per BWF Level 3 manual Chapter 9), these fields are **not displayed** anywhere in `DrillIntroScreen.dart`. The user has no way of reading them.

## 3. Minor Issues (P2 – Nice to Improve)
*   **Audio Issue (TTS Fallback):** `VoiceCoachService` blindly calls `flutter_tts.speak()`. If a user's device lacks a TTS engine, has it disabled, or lacks the requested language pack, the app silently swallows the error instead of falling back to standard audio beeps.
*   **Performance / Asset Optimization:** The 4 newly generated 3D avatars in `assets/images/avatars/` are roughly 500KB - 750KB each. Loading all 4 in the `SettingsScreen` bottom sheet simultaneously without `cacheHeight`/`cacheWidth` parameters will cause unnecessary memory spikes. They should be compressed to <50KB each.

## 4. UI Improvements
*   **[P2] Overflow Risk:** `FeatureCard` text in the `HomeScreen` GridView relies on `FittedBox`. While safe from crashes, long translations of "Tactical Puzzles" in other languages will shrink to illegibly small font sizes on narrow devices like the iPhone SE.
*   **[P2] Missing Empty States:** `MentalCornerScreen` and `TacticalPuzzlesScreen` currently seem to be placeholder routes. If they contain no data, they need the premium empty state UI pattern used in `drills_screen.dart`.

## 5. UX Improvements
*   **[P2] Navigation Clutter:** There are too many overlapping paths to drills (`DrillsScreen`, `FootworkScreen`, `ShadowMovementScreen`). This creates cognitive load. Consolidate these under a unified "Training Library" tab.
*   **[P2] Custom Rest Intervals:** While 45 seconds strictly adheres to the 1:1 sports science ratio, users with different cardiovascular baselines will find it either too long or too short. Add a "Custom Rest Duration" slider in the Settings Suite.

## 6. Coaching Improvements
*   **[P1] Missing Progression Visibility:** To fully satisfy the BWF Manual, the `DrillIntroScreen` must explicitly display the `completionCriteria` so athletes know exactly what metric defines "mastery" before moving to the next progression step.

## 7. Performance Improvements
*   **[P1] Isolate Timer State:** Move the countdown text into its own `StatefulWidget` or use a `ValueNotifier<int>` so that only the text widget rebuilds every second, rather than the entire `PremiumTrainingSessionScreen`.
*   **[P2] Image Caching:** Use `precacheImage` during the splash/onboarding phase for the heavy avatar assets to prevent layout stutter when opening the Profile edit sheet.
