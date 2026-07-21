# Phase 3 UX/UI Audit Report
## Overview
A comprehensive evaluation of the `lib/presentation/screens/` and `lib/presentation/widgets/` directories to identify areas for improvement from the perspective of a professional athlete.

## Detailed Findings & Phase 5 Action Plan

### 1. Navigation Flow
*   **Issue**: `TrainScreen` requires extra taps to begin the "Today's Drill" if users miss the hero card, forcing them to navigate through nested menus.
*   **Fix**: Introduce a prominent, floating "Quick Start: Daily Drill" FAB (Floating Action Button) or sticky footer on the `TrainScreen` and `HomeScreen` to bypass hierarchy and instantly launch the day’s primary drill.

### 2. UI Motivation
*   **Issue**: Terminology in `train_screen.dart` ("Training Hierarchy", "Select a badminton training module") feels overly academic and sterile.
*   **Fix**: Update copy to use active, athlete-centric verbs. Change "Training Hierarchy" to "Your Training Arsenal" or "Coaching Modules", and "Select a badminton training module..." to "Choose your focus area and put in the work."

### 3. Scannability
*   **Issue**: `ProfileScreen` relies too heavily on text for the "Athlete Profile Details" row (e.g., Playing Level, Primary Goal). It is dense and hard to parse quickly.
*   **Fix**: Add subtle, relevant icons (e.g., a racket icon for 'Dominant Hand', a calendar for 'Age') to the `_buildProfileRow` function to enhance visual parsing.

### 4. Interactions
*   **Issue**: `TrainingBottomNav` uses standard system `AlertDialog`s for "Skip Phase" and "Previous Phase" confirmations, which breaks immersion and feels unpolished.
*   **Fix**: Replace standard alerts with custom, premium bottom modal sheets (`showModalBottomSheet`) styled with the app’s `AppColors.courtSurface` and rounded corners to maintain the athletic focus flow.

### 5. Scroll Minimization
*   **Issue**: `HomeScreen` and `TrainScreen` feature long vertical scrolling lists (e.g., the 2-column feature card grid and vertical list of training cards).
*   **Fix**: Convert the less frequently used sections (like "Mental Corner" and "Tutorials") into horizontal scrolling carousels, keeping the primary physical drills (Solo Drills, Footwork) visible without scrolling.

### 6. Reachability
*   **Issue**: Important top-of-screen actions (like the Edit Profile button in `ProfileScreen` or AI Coach Hub in `HomeScreen`) are difficult to reach one-handed on larger screens during a workout.
*   **Fix**: Move core contextual actions (like 'Edit') into a bottom sheet menu triggered by tapping the avatar, and move the AI Coach button closer to the thumb zone.

### 7. Premium Feel
*   **Issue**: While `AppCard` has a nice scale animation, empty UI states or standard text fields (like the Edit Profile modal in `ProfileScreen`) lack the energetic gradients seen in `GradientHeroCard`.
*   **Fix**: Inject subtle animated gradient borders or glow effects into active text fields and primary actions to heighten the premium athletic aesthetic.

### 8. Responsiveness
*   **Issue**: `FeatureCard` and `_buildCategoryCard` heavily rely on `FittedBox` to prevent text overflow. While safe, it can cause text sizes to become inconsistently tiny on narrower devices.
*   **Fix**: Use dynamic typography (e.g., `MediaQuery` or `LayoutBuilder` based font scaling) instead of pure `FittedBox` scaling, and allow multi-line text wrapping with `maxLines: 2` for grid titles where necessary.

### 9. Typography
*   **Issue**: The typographic hierarchy between section titles and body text sometimes blends together (e.g., `SectionTitle` widget vs. standard bold text).
*   **Fix**: Increase letter spacing (`letterSpacing: 1.2`) and use uppercase styling for all `SectionTitle` widgets to clearly delineate distinct dashboard sections. Keep JetBrainsMono for numerical data (timers, stats) to emphasize performance.

### 10. Spacing
*   **Issue**: Dense information packing in `ActiveReactionSessionScreen` and `TacticalPuzzlesScreen` can lead to accidental mis-taps during high-heart-rate sessions.
*   **Fix**: Increase touch targets and padding between selectable options (e.g., tactical puzzle answers or drill settings) to a minimum of 24px spacing, ensuring sweaty fingers don't tap the wrong button.

### 11. Empty States
*   **Issue**: In `DrillsScreen`, the "Top Favourite Drills" list completely disappears if empty. In `ProfileScreen`, missing biometrics just show "Not set". This represents a missed opportunity for user engagement.
*   **Fix**: Implement motivational empty states. For favorites, show a dashed placeholder card saying "Tap the heart on a drill to add it to your quick-access favorites." For the profile, show a prominent "Complete your athlete profile" CTA to encourage data entry.
