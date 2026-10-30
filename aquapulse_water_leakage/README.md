# AquaPulse – Water Leakage Reporting & Complaint Management System

A realistic, professional Flutter mobile and web application built for college practicals, evaluations, and municipal water management workflows.

---

## 🌟 Key Features

1. **Animated Water Splash & Onboarding**
   - Ripple water animation using Flutter's animation framework (`AnimationController`, custom canvas painter).
   - Interactive onboarding flow highlighting reporting, live tracking, and water conservation.

2. **Secure Multi-Role Authentication**
   - Citizen registration with email uniqueness checks, 10-digit mobile validation, and password confirmation.
   - Salted SHA-256 password hashing (passwords are never stored in plaintext).
   - Dedicated administrative access flow with role-guard protection.
   - Convenient one-tap **Auto-Fill Demo Credentials** for fast evaluation/viva testing.

3. **User Dashboard & Real-Time Statistics**
   - Live summary metrics: Total Complaints, Pending, In Progress, Resolved.
   - Prominent "Report a Leak" quick action banner.
   - Water conservation tips and recent complaint history.
   - Integrated live REST API card (fetching real atmospheric conditions from Open-Meteo).

4. **Complaint Submission Form**
   - Comprehensive form inputs: Category dropdown, severity selector (Low, Medium, High, Critical), address, landmark, date/time picker, detailed description, and photo attachment.
   - Automated ID generation: `AP-2026-XXXX`.
   - Double-submission prevention with loading state.
   - Celebratory success screen with direct tracking navigation.

5. **User Complaint Tracking & Visual Lifecycle**
   - Filter complaints by *All*, *Pending*, *In Progress*, *Resolved*.
   - Visual 4-stage lifecycle tracker: **Reported → Reviewed → In Progress → Resolved**.
   - Chronological status transition history with remarks and inspection logs.
   - Strict citizen data isolation (users cannot see other citizens' private reports).

6. **Department Admin Portal**
   - Department-wide visibility of **ALL** complaints from all citizens.
   - 6-metric summary: Total, Pending, In Progress, Resolved, High Priority, Critical.
   - Real-time search by ID, title, locality, landmark, or citizen name.
   - Filtering by status, severity, and sorting by newest, oldest, or priority.
   - Dispatch workflow: change status, record official remarks, and enter resolution reports.

7. **Automatic In-App Notifications**
   - When an admin updates any complaint status or marks it resolved, an in-app notification is automatically generated in SQLite for the original complainant.
   - Real-time unread badge counter in top app bar and bottom navigation.
   - Direct navigation from notification to the specific complaint details.
   - Mark individual or all notifications as read.

8. **Multiplatform Database Architecture**
   - **Android / iOS**: Local SQLite storage via `sqflite`.
   - **Web / Windows / Test**: Automated in-memory SQLite emulation adapter (`WebMemoryDatabaseAdapter`) preventing native binary crashes.

---

## 🔑 Documented Demo Credentials

| Role | Email | Password | Purpose |
|---|---|---|---|
| **Citizen (User)** | `citizen@aquapulse.org` | `Citizen@123` | Report leaks, track complaint progress, receive status notifications |
| **Department Admin** | `admin@aquapulse.org` | `Admin@123` | View all citizen complaints, search/filter, dispatch crews, resolve complaints |

*(Both login screens include an "Auto-Fill" button for instant one-tap testing during viva/evaluation.)*

---

## 🚀 How to Run on Windows (VS Code)

### 1. Open Project in VS Code
Open PowerShell and navigate to the project directory:
```powershell
cd c:\Users\Rohini\Desktop\aquapulse\aquapulse_water_leakage
code .
```

### 2. Fetch Packages
```powershell
flutter pub get
```

### 3. Run the App
- **In Google Chrome (Recommended for fast practical evaluation):**
  ```powershell
  flutter run -d chrome
  ```
- **On Android Device or Emulator:**
  ```powershell
  flutter run -d android
  ```
- **On Windows Desktop:**
  ```powershell
  flutter run -d windows
  ```

### 4. Run the College Experiment 1(b) Fundamentals Script
```powershell
dart run bin/dart_fundamentals_demo.dart
```

---

## 🧪 Testing and Verification

Run the complete automated unit and widget test suite:
```powershell
flutter test
```
*Result: 22/22 unit and widget tests pass.*

Verify static analysis:
```powershell
flutter analyze
```
*Result: No issues found! (0 errors, 0 warnings).*

Format code according to official Dart conventions:
```powershell
dart format .
```

---

## 📁 Project Architecture & Folder Structure

```text
aquapulse_water_leakage/
├── bin/
│   └── dart_fundamentals_demo.dart       # Experiment 1(b) standalone script
├── lib/
│   ├── main.dart                          # App entry point & DB initialization
│   ├── app.dart                           # MultiProvider, MaterialApp & Routes
│   ├── core/
│   │   ├── constants/app_constants.dart   # Brand constants, demo accounts & endpoints
│   │   ├── routes/app_routes.dart         # Named routes table
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # Full color palette (Teal, Aqua, Coral, Violet, Mint)
│   │   │   └── app_theme.dart             # Material 3 ThemeData system
│   │   └── utils/
│   │       ├── date_formatter.dart        # Date & relative time formatting (intl)
│   │       ├── password_hasher.dart       # SHA-256 salted password hashing
│   │       └── validators.dart            # Form input validation rules
│   ├── models/
│   │   ├── user_model.dart                # User entity
│   │   ├── complaint_model.dart           # Complaint entity
│   │   ├── complaint_history_model.dart   # Status audit trail entity
│   │   ├── notification_model.dart        # In-app notification entity
│   │   └── environmental_model.dart       # REST API environmental weather model
│   ├── database/
│   │   ├── database_adapter.dart          # Database abstraction interface
│   │   ├── mobile_database_adapter.dart   # SQLite / sqflite driver for Android/iOS
│   │   ├── web_memory_database_adapter.dart # Web & desktop in-memory SQLite store
│   │   └── app_database.dart              # Factory singleton with platform auto-detection
│   ├── repositories/
│   │   ├── auth_repository.dart           # Auth, registration, profile & password queries
│   │   ├── complaint_repository.dart      # Complaint CRUD, admin queries & notification hooks
│   │   └── notification_repository.dart   # Notification queries & read status updates
│   ├── services/
│   │   ├── api_service.dart               # HTTP client fetching Open-Meteo REST API
│   │   └── session_service.dart           # SharedPreferences session persistence
│   ├── providers/
│   │   ├── auth_provider.dart             # Auth & user state management
│   │   ├── complaint_provider.dart        # Complaint list, filtering, counts & submissions
│   │   ├── notification_provider.dart     # Notifications & unread badge state
│   │   └── environmental_provider.dart    # Live environmental API state
│   ├── widgets/
│   │   ├── app_button.dart                # Custom themed button with loading indicator
│   │   ├── app_text_field.dart            # Styled text input with password toggle
│   │   ├── app_card.dart                  # Elevated card container
│   │   ├── status_badge.dart              # Colored status pill (Pending/Reviewed/In Progress/Resolved)
│   │   ├── severity_badge.dart            # Colored severity tag (Low/Medium/High/Critical)
│   │   ├── stat_card.dart                 # Dashboard statistic card
│   │   ├── complaint_card.dart            # Complaint summary item
│   │   ├── progress_tracker.dart          # 4-stage visual lifecycle stepper
│   │   ├── notification_card.dart         # Notification alert item
│   │   ├── responsive_layout.dart         # Breakpoint manager & content width wrapper
│   │   ├── empty_state_view.dart          # Empty view with illustration icon & action
│   │   └── error_state_view.dart          # Error view with retry button
│   └── screens/
│       ├── splash/splash_screen.dart      # Animated ripple splash screen
│       ├── onboarding/onboarding_screen.dart # 3-step feature onboarding carousel
│       ├── auth/
│       │   ├── login_screen.dart          # Citizen sign in with demo autofill
│       │   ├── register_screen.dart       # Citizen account registration
│       │   └── admin_login_screen.dart    # Department admin access portal
│       ├── dashboard/
│       │   ├── user_dashboard_screen.dart # Main citizen shell (BottomNav / NavRail)
│       │   └── home_tab.dart              # Dashboard metrics, API widget & quick actions
│       ├── complaints/
│       │   ├── report_complaint_screen.dart # Water leak complaint form
│       │   ├── complaint_success_screen.dart# Submission confirmation with ID
│       │   ├── my_complaints_screen.dart    # User's complaint list with filters
│       │   └── complaint_details_screen.dart# Full complaint details & progress tracker
│       ├── notifications/
│       │   └── notifications_screen.dart  # In-app notifications with unread counter
│       ├── profile/profile_screen.dart    # Profile view, editing dialog & sign out
│       └── admin/
│           ├── admin_dashboard_screen.dart# Admin console with 6 metrics & filters
│           └── admin_complaint_details_screen.dart # Status updater & notification trigger
├── test/
│   ├── unit/
│   │   ├── validators_test.dart           # Form validation unit tests
│   │   ├── password_hasher_test.dart      # Cryptographic hashing unit tests
│   │   ├── complaint_model_test.dart      # Model serialization tests
│   │   └── complaint_repository_test.dart # Multi-user isolation & auto-notification tests
│   ├── widget/
│   │   ├── badges_test.dart               # Badge widgets visual tests
│   │   ├── stat_card_test.dart            # Metric cards interaction tests
│   │   └── login_screen_test.dart         # Login layout & validation tests
│   └── widget_test.dart                   # Smoke test for AquaPulseApp
├── PRACTICAL_RECORD_EXPERIMENTS.md        # Full manual for Experiments 1(a) to 10(b)
└── pubspec.yaml                           # Dependency definitions
```

---

## 📚 College Practicals Manual
Refer to [`PRACTICAL_RECORD_EXPERIMENTS.md`](PRACTICAL_RECORD_EXPERIMENTS.md) for detailed documentation of all 10 experiments (Aim, Requirements, Description, Code, Procedure, Expected Output, and Result).
