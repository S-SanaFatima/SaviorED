# Profile & Focus Time Integration Guide ✅

## **Status: Profile Dashboard Complete ✅**

The profile dashboard has been fully integrated with the backend and displays real-time data.

---

## ✅ **Completed: Profile Dashboard**

### **1. ProfileViewModel Created**
- **File:** `lib/core/features/profile/viewmodels/profile_viewmodel.dart`
- Fetches user profile data from `/api/users/profile`
- Calculates level progression and XP progress
- Handles profile updates (name, avatar)

### **2. ProfileView Updated**
- **File:** `lib/core/features/profile/view/profile_view.dart`
- Displays real user data:
  - Avatar (from backend or default)
  - Name and Email
  - Level and Experience Points
  - Focus Hours, Sessions, Coins
  - XP Progress Bar with percentage
- Shows XP needed for next level
- Auto-refreshes when opened

### **3. Level & XP System**

**Formula (from backend):**
- Level calculation: `level = floor(sqrt(XP / 100)) + 1`
- XP earned: 10 XP per minute of focused time
- Progress calculation in ProfileViewModel:
  - Current Level XP Range
  - Next Level XP Requirement
  - Progress Percentage

**Level Progression Examples:**
- Level 1: 0 XP
- Level 2: 100 XP (need 100 XP)
- Level 3: 400 XP (need 300 XP more)
- Level 4: 900 XP (need 500 XP more)
- Level 5: 1600 XP (need 700 XP more)

---

## 📋 **Focus Time Integration Status**

### **Current Implementation**
The `FocusTimeView` currently uses:
- Local state management (no backend integration)
- Local storage for persistence
- Timer runs completely client-side

### **FocusTimeViewModel Available**
- `createSession()` - Creates session in backend ✅
- `updateSession()` - Updates session state ✅
- `completeSession()` - Completes session and gets rewards ✅
- Methods are ready but **not currently used** in FocusTimeView

---

## 🔧 **Integration Requirements for Focus Time**

To fully integrate focus time tracking with backend:

### **1. Session Creation (When Timer Starts)**
```dart
// In _startTimer() method
final focusTimeViewModel = Provider.of<FocusTimeViewModel>(context, listen: false);
final session = await focusTimeViewModel.createSession(_initialDurationMinutes);
if (session != null) {
  // Store session ID for updates
  _sessionId = session.id;
}
```

### **2. Session Updates (Periodic Updates)**
```dart
// Every 30 seconds or on pause/resume
if (_sessionId != null) {
  await focusTimeViewModel.updateSession(
    sessionId: _sessionId!,
    totalSeconds: (_initialDurationMinutes * 60) - _totalSeconds,
    isPaused: _isPaused,
    isRunning: _isRunning,
  );
}
```

### **3. Session Completion (When Timer Ends)**
```dart
// In _showCompletionDialog() or when timer completes
if (_sessionId != null) {
  final completedSeconds = (_initialDurationMinutes * 60) - _totalSeconds;
  final rewards = await focusTimeViewModel.completeSession(
    sessionId: _sessionId!,
    totalSeconds: completedSeconds,
  );
  
  if (rewards != null) {
    // Show rewards (coins, stones, wood, XP)
    // Refresh profile to show updated stats
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.refresh();
  }
}
```

### **4. Profile Refresh After Completion**
```dart
// After session completion
final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
await profileViewModel.refresh(); // Updates level, XP, stats
```

---

## 📊 **Backend Integration Points**

### **Profile Endpoint**
- **GET** `/api/users/profile`
  - Returns: level, XP, focus hours, sessions, coins
  - Used by: ProfileViewModel

### **Focus Session Endpoints**
- **POST** `/api/focus-sessions` - Create session
- **PUT** `/api/focus-sessions/:id/update` - Update session
- **PUT** `/api/focus-sessions/:id/complete` - Complete session
  - Returns: rewards (coins, stones, wood, XP, levelUp info)
  - Used by: FocusTimeViewModel (methods exist, need integration)

---

## ✅ **What Works Now**

1. **Profile Dashboard:**
   - ✅ Shows real user data from backend
   - ✅ Displays level, XP, progress bar
   - ✅ Shows stats (focus hours, sessions, coins)
   - ✅ Calculates XP progression correctly
   - ✅ Updates profile name/avatar
   - ✅ Auto-loads on view open

2. **Focus Time View:**
   - ✅ Timer works (client-side)
   - ✅ Local persistence works
   - ⚠️ **Not integrated with backend** (sessions not created/completed in backend)
   - ⚠️ **XP/Rewards not earned** (because sessions aren't completed in backend)

---

## 🔄 **How to Complete Focus Time Integration**

### **Step 1: Add Session State to FocusTimeView**
```dart
String? _sessionId; // Store backend session ID
```

### **Step 2: Create Session When Timer Starts**
Call `createSession()` when user starts timer.

### **Step 3: Update Session Periodically**
Update session every 30-60 seconds with current progress.

### **Step 4: Complete Session When Timer Ends**
Call `completeSession()` when timer reaches 0, show rewards.

### **Step 5: Refresh Profile After Completion**
Call `profileViewModel.refresh()` to show updated stats.

---

## 💡 **Recommendations**

1. **Keep Local Timer**: Continue using local timer for responsive UI
2. **Backend for Rewards**: Use backend for session tracking and rewards
3. **Periodic Sync**: Sync session state to backend every 30 seconds
4. **Completion Sync**: Always complete session in backend when timer finishes
5. **Profile Refresh**: Refresh profile after session completion to show updated stats

---

## 📝 **Summary**

- ✅ **Profile Dashboard**: Fully integrated, shows real-time data
- ⚠️ **Focus Time**: Timer works but not integrated with backend for rewards
- 📋 **Next Steps**: Integrate FocusTimeView with FocusTimeViewModel for backend session tracking

**The profile dashboard is production-ready!** The focus time integration requires additional work to connect the existing timer logic with the backend session APIs.

