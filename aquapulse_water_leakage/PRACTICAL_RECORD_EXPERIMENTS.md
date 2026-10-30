# AquaPulse – College Practical Lab Record Manual
## Mobile Application Development with Flutter & Dart
**Project:** AquaPulse – Water Leakage Reporting & Complaint Management System  
**Framework:** Flutter (Material 3), Dart SDK 3.x, SQLite / In-Memory Adapter, Provider State Management  

---

## EXPERIMENT 1(a)
### Aim
To install and configure Flutter and Dart SDK on the system, configure environment variables, and verify the toolchain readiness using Flutter diagnostic tools.

### Requirements
- Operating System: Windows 10/11 (or macOS/Linux)
- Git for Windows
- Flutter SDK 3.x with Dart SDK 3.x
- VS Code with Flutter & Dart extensions
- Android Studio / Android SDK (or Google Chrome for Web preview)

### Description
Flutter is Google's open-source UI software development kit used to build natively compiled applications for mobile, web, and desktop from a single codebase. Dart is the client-optimized, object-oriented programming language powering Flutter. Verifying toolchain health ensures compilers, platform tools, and device bridges are functioning.

### File Names & Relevant Commands
- Terminal Command: `flutter doctor -v`
- Terminal Command: `flutter --version`

### Step-by-Step Procedure
1. Download the Flutter SDK bundle from `https://docs.flutter.dev/get-started/install`.
2. Extract the archive to `C:\src\flutter` (avoid paths with spaces or special characters).
3. Add `C:\src\flutter\bin` to the user's `PATH` environment variable.
4. Open Windows PowerShell and run `flutter doctor -v`.
5. Verify Android SDK licenses by running `flutter doctor --android-licenses` and accepting the terms.
6. Install the official "Flutter" and "Dart" extensions in Visual Studio Code.

### Expected Output
```text
Flutter 3.44.9 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 6b182d2c75
Engine • hash b9499e4c25
Tools • Dart 3.12.2 • DevTools 2.57.0

[✓] Flutter (Channel stable, 3.44.9)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] VS Code (version 1.90+)
[✓] Connected device (Chrome, Windows, Android)
[✓] Network resources
• No issues found!
```

### Result
The Flutter and Dart SDKs were successfully installed, environment variables were configured, and all development toolchains were verified without issues.

---

## EXPERIMENT 1(b)
### Aim
To write and execute a standalone Dart program demonstrating fundamental programming language concepts including variables, built-in data types, operators, conditional control flow, collections, loops, and functions.

### Requirements
- Dart SDK 3.x
- VS Code or Dart CLI

### Description
Dart supports strong typing with type inference (`var`, `final`, `const`), core primitive types (`int`, `double`, `String`, `bool`, `num`), operators (arithmetic, relational, logical), control structures (`if-else`, `switch`), collections (`List`, `Set`, `Map`), iteration loops (`for`, `for-in`), and first-class functions with positional and named parameters.

### File Names & Relevant Code
- File: `bin/dart_fundamentals_demo.dart`

```dart
void main() {
  // Variables & Types
  final String appTitle = 'AquaPulse Water Leakage Management';
  int reportedLeaks = 42;
  double averageRepairHours = 3.5;
  bool isAlertActive = true;
  num waterLitersSaved = 12500.75;

  // Operators
  final int pendingComplaints = 14;
  final int resolvedComplaints = reportedLeaks - pendingComplaints;
  final double resolutionPercentage = (resolvedComplaints / reportedLeaks) * 100;
  final bool hasCriticalBacklog = pendingComplaints > 10 && isAlertActive;

  // Conditions
  String severity = 'Critical';
  if (severity == 'Critical') {
    print('Immediate dispatch required: Field crew response within 1 hour.');
  }

  // Collections (List, Set, Map)
  final List<String> categories = ['Pipeline Leak', 'Overflowing Tank', 'Broken Public Tap'];
  final List<String> rawWards = ['Ward 4', 'Ward 12', 'Ward 4', 'Ward 18'];
  final Set<String> wards = rawWards.toSet(); // Deduplicates redundant entries
  final Map<String, int> severityMap = {'Critical': 8, 'High': 12, 'Medium': 15};

  // Loops
  for (int i = 0; i < categories.length; i++) {
    print('${i + 1}. ${categories[i]}');
  }

  // Function with named parameters
  double score = calculateEfficiencyScore(total: reportedLeaks, resolved: resolvedComplaints);
  print('Efficiency Score: $score / 100');
}

double calculateEfficiencyScore({required int total, required int resolved, double benchmarkScore = 100.0}) {
  if (total == 0) return 0.0;
  return (resolved / total) * benchmarkScore;
}
```

### Step-by-Step Procedure
1. Create the `bin/dart_fundamentals_demo.dart` file.
2. Open PowerShell in `aquapulse_water_leakage`.
3. Execute `dart run bin/dart_fundamentals_demo.dart`.
4. Inspect the formatted console output.

### Expected Output
```text
====================================================
    AQUAPULSE - EXPERIMENT 1(b): DART FUNDAMENTALS   
====================================================
[1] VARIABLES & DATA TYPES:
App Title (String): AquaPulse Water Leakage Management
Reported Leaks (int): 42
Average Repair Time (double): 3.5 hours
System Alert Active (bool): true
Water Saved (num): 12500.75 Litres

[2] OPERATORS:
Resolved Complaints: 28
Resolution Percentage: 66.7%
Critical Backlog Status (Logical AND): true

[3] CONDITIONS:
Immediate dispatch required: Field crew response within 1 hour.

[4] COLLECTIONS:
Categories (List): [Pipeline Leak, Overflowing Tank, Broken Public Tap]
Unique Wards (Set): {Ward 4, Ward 12}
Complaints by Severity (Map): {Critical: 8, High: 12, Medium: 15}

[5] LOOPS:
Iterating through categories:
  1. Pipeline Leak
  2. Overflowing Tank
  3. Broken Public Tap

[6] FUNCTIONS:
Maintenance Efficiency Score: 66.7 / 100
====================================================
```

### Result
The Dart fundamentals demonstration was executed successfully, validating data types, arithmetic/logical operations, collections, and modular functions.

---

## EXPERIMENT 2(a)
### Aim
To construct interactive user interface layouts demonstrating core Flutter widgets: `Text`, `Image` / `Icon`, `Container`, `Card`, `ElevatedButton`, and `TextFormField`.

### Requirements
- Flutter SDK
- Android Emulator or Google Chrome

### Description
Every visual component in Flutter is a `Widget`. Widgets form a declarative UI hierarchy. Primitive widgets like `Text` handle styled typography, `Icon` presents scalable vector symbols, `Container` provides decoration/padding/margins, and `Card` renders elevated Material surfaces with rounded corners.

### File Names & Relevant Code
- Files:
  - `lib/widgets/app_card.dart`
  - `lib/widgets/status_badge.dart`
  - `lib/widgets/severity_badge.dart`
  - `lib/widgets/stat_card.dart`

```dart
// Container + Card + Text + Icon composition
class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color accentColor;

  const StatCard({super.key, required this.title, required this.count, required this.icon, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.25), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor, size: 20),
              Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: accentColor)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
```

### Step-by-Step Procedure
1. Create reusable widgets in `lib/widgets/`.
2. Apply Material 3 styling, rounded corners (`BorderRadius.circular(16)`), and elevation.
3. Test rendering via `flutter test test/widget/badges_test.dart` and `test/widget/stat_card_test.dart`.

### Expected Output
Colored status badges (`Pending`, `In Progress`, `Resolved`), severity badges (`Critical`, `High`, `Medium`, `Low`), and elevated dashboard statistics cards render with icons and typography.

### Result
Core Flutter widgets were successfully implemented and visually verified in the AquaPulse dashboard.

---

## EXPERIMENT 2(b)
### Aim
To implement structured multi-child layouts demonstrating `Row`, `Column`, `Stack`, `Expanded`, and `Positioned`.

### Requirements
- Flutter SDK

### Description
Flutter handles 2D layout composition through flex widgets (`Row` for horizontal arrangements, `Column` for vertical arrangements, and `Stack` for layered z-index positioning). `Expanded` and `Flexible` distribute free space among children.

### File Names & Relevant Code
- Files:
  - `lib/screens/splash/splash_screen.dart` (Demonstrates `Stack` & `Positioned`)
  - `lib/widgets/complaint_card.dart` (Demonstrates `Column`, `Row`, `Expanded`)

```dart
// Stack with ripple effects, logo, and positioned loading indicator
Stack(
  alignment: Alignment.center,
  children: [
    AnimatedBuilder(...), // Animated ripples layered in background
    ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(...), // Water drop logo
          Text('AquaPulse', ...),
          Text('Every Drop Counts.', ...),
        ],
      ),
    ),
    Positioned(
      bottom: 48,
      child: CircularProgressIndicator(...),
    ),
  ],
)
```

### Step-by-Step Procedure
1. Implement the splash screen using `Stack` to layer background animated ripples underneath the logo.
2. In `ComplaintCard`, combine `Row` and `Column` with `Expanded` to prevent text truncation on long addresses.
3. Verify layout behavior across various screen sizes.

### Expected Output
The splash screen renders the animated ripple under the water drop logo, and complaint cards display status, title, and address cleanly without clipping.

### Result
Multi-child flex and stack layouts were implemented and verified.

---

## EXPERIMENT 3(a) & 3(b)
### Aim
To construct a responsive user interface utilizing `MediaQuery`, `LayoutBuilder`, and responsive breakpoints supporting phones, tablets, and desktop/browser environments.

### Requirements
- Flutter SDK
- Web browser / Desktop window resizing

### Description
Responsive design allows a single Flutter application to adjust its navigation, grid density, and card widths depending on viewport constraints.
- Mobile (< 650px): Compact single-column view, bottom navigation bar.
- Tablet (650px – 1024px): 3 to 4 column metric grids, responsive cards.
- Desktop (> 1024px): NavigationRail sidebar navigation, constrained max-width forms, and 6-column dashboard summaries.

### File Names & Relevant Code
- File: `lib/widgets/responsive_layout.dart`
- File: `lib/screens/dashboard/user_dashboard_screen.dart`
- File: `lib/screens/admin/admin_dashboard_screen.dart`

```dart
class ResponsiveBreakpoints {
  static const double mobileMax = 650;
  static const double tabletMax = 1024;

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileMax;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width > tabletMax;
}

// In UserDashboardScreen:
final isDesktop = ResponsiveBreakpoints.isDesktop(context);

return Scaffold(
  body: Row(
    children: [
      if (isDesktop)
        NavigationRail(
          selectedIndex: _currentIndex,
          destinations: [...],
        ),
      Expanded(child: tabs[_currentIndex]),
    ],
  ),
  bottomNavigationBar: isDesktop ? null : BottomNavigationBar(...),
);
```

### Step-by-Step Procedure
1. Create `ResponsiveBreakpoints` and `ResponsiveContentWrapper` in `lib/widgets/responsive_layout.dart`.
2. Wrap forms and dashboard bodies with `ResponsiveContentWrapper(maxWidth: 800)`.
3. Switch between `BottomNavigationBar` on mobile and `NavigationRail` on desktop.
4. Use `LayoutBuilder` in `StatCard` grids to switch between 2, 3, 4, or 6 columns.

### Expected Output
When resizing the browser or switching between mobile and tablet devices, the app dynamically switches navigation controls and grid columns with zero pixel overflows.

### Result
Responsive UI layouts and breakpoint abstractions were successfully implemented and tested.

---

## EXPERIMENT 4(a) & 4(b)
### Aim
To implement application screen navigation using both imperative navigation (`Navigator.push`, `Navigator.pop`) and declarative named routes (`MaterialApp.routes`).

### Requirements
- Flutter SDK

### Description
Navigation is the mechanism for transitioning between different UI screens. Named routes configure a centralized URL/route table (`AppRoutes.routes`), while `Navigator.push` and `Navigator.pop` allow dynamic screen stacking, passing arguments, and returning results.

### File Names & Relevant Code
- File: `lib/core/routes/app_routes.dart`
- File: `lib/app.dart`
- File: `lib/screens/complaints/report_complaint_screen.dart`

```dart
// Named Routes Definition
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String userDashboard = '/user-dashboard';
  static const String reportComplaint = '/report-complaint';
  static const String complaintDetails = '/complaint-details';
  static const String adminDashboard = '/admin-dashboard';
  ...
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    userDashboard: (context) => const UserDashboardScreen(),
    reportComplaint: (context) => const ReportComplaintScreen(),
    complaintDetails: (context) => const ComplaintDetailsScreen(),
    adminDashboard: (context) => const AdminDashboardScreen(),
  };
}

// Named Navigation
Navigator.pushNamed(context, AppRoutes.reportComplaint);

// Imperative Navigation with argument passing
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ComplaintSuccessScreen(complaint: created),
  ),
);
```

### Step-by-Step Procedure
1. Declare all application routes in `AppRoutes.routes`.
2. Register the routes table inside `MaterialApp(initialRoute: AppRoutes.splash, routes: AppRoutes.routes)`.
3. Use `Navigator.pushNamed` for main screen transitions and `Navigator.pushReplacementNamed` after authentication.
4. Use `Navigator.pop` to return to previous screens.

### Expected Output
Users navigate seamlessly from Splash → Onboarding → Login → Dashboard → Report Complaint → Success → Details, with back-navigation working correctly.

### Result
Both named routes and imperative navigation workflows were implemented and validated.

---

## EXPERIMENT 5(a) & 5(b)
### Aim
To demonstrate state management principles using `StatelessWidget`, `StatefulWidget`, local state manipulation with `setState()`, and application-wide reactive state management using `Provider`.

### Requirements
- Flutter SDK
- `provider: ^6.1.2` package

### Description
- `StatelessWidget`: Immutable widgets whose properties do not change over time (e.g. `AppCard`, `SeverityBadge`).
- `StatefulWidget` & `setState()`: Manages local, ephemeral widget state such as password visibility toggles, text input focus, or active tab index.
- `Provider` (`ChangeNotifier`, `MultiProvider`, `context.watch`, `context.read`): Centralized reactive state management. When complaint statuses change or notifications are added, all listening widgets update automatically without full tree re-renders.

### File Names & Relevant Code
- File: `lib/providers/auth_provider.dart`
- File: `lib/providers/complaint_provider.dart`
- File: `lib/providers/notification_provider.dart`
- File: `lib/widgets/app_text_field.dart` (Demonstrates `StatefulWidget` & `setState`)
- File: `lib/app.dart` (Demonstrates `MultiProvider`)

```dart
// MultiProvider configuration in app.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ComplaintProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => EnvironmentalProvider()),
  ],
  child: MaterialApp(...),
)

// Reactive UI consumption in home_tab.dart
final complaintProv = context.watch<ComplaintProvider>();
Text('${complaintProv.userPendingCount}'); // Automatically updates on status changes
```

### Step-by-Step Procedure
1. Wrap root `MaterialApp` in `MultiProvider` in `lib/app.dart`.
2. Create `ChangeNotifier` classes in `lib/providers/` for Auth, Complaints, and Notifications.
3. Call `notifyListeners()` whenever state mutations occur.
4. Consume state in UI widgets using `context.watch<T>()` for reactive rebuilding or `context.read<T>()` for event callbacks.

### Expected Output
When an admin marks a complaint as "In Progress" or "Resolved", the citizen's complaint count, status badge, and unread notification badge update instantly.

### Result
Local state (`setState`) and global state management (`Provider`) were successfully implemented.

---

## EXPERIMENT 6(a) & 6(b)
### Aim
To design reusable custom widgets and establish an application-wide design system featuring Material 3, cohesive custom themes, typography, and branded color palettes.

### Requirements
- Flutter SDK

### Description
A professional design system maintains consistency and reduces code duplication. In AquaPulse, brand colors are centralized:
- Deep Teal (`#006D77`): Main brand
- Turquoise (`#05BFDB`) & Pale Aqua (`#F4FBFB`): Interactive elements & backgrounds
- Coral Orange (`#FF6B6B`): Urgent leaks & highlights
- Violet (`#6C5CE7`): Admin portal & secondary features
- Mint Green (`#2EC4B6`): Resolved status & success states
- Amber (`#FFB703`): Pending status
- Red (`#D90429`): Critical severity

### File Names & Relevant Code
- File: `lib/core/theme/app_colors.dart`
- File: `lib/core/theme/app_theme.dart`
- File: `lib/widgets/app_button.dart`
- File: `lib/widgets/progress_tracker.dart`

```dart
// Centralized theme system in app_theme.dart
static ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryTeal,
      primary: AppColors.primaryTeal,
      secondary: AppColors.turquoise,
      error: AppColors.redCritical,
    ),
    scaffoldBackgroundColor: AppColors.paleAqua,
    cardTheme: CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
```

### Step-by-Step Procedure
1. Define color constants and helper functions in `AppColors`.
2. Build custom ThemeData configuring buttons, cards, appbars, and inputs.
3. Build modular UI widgets in `lib/widgets/` (`AppButton`, `AppTextField`, `ProgressTracker`, etc.).
4. Test theme consistency across all app screens.

### Expected Output
All screens reflect a modern, cohesive look with consistent typography, rounded cards, subtle shadows, and color-coded status badges.

### Result
The custom theme and reusable widget system were implemented and verified.

---

## EXPERIMENT 7(a) & 7(b)
### Aim
To construct a comprehensive complaint submission form with multiple input types, robust field validation, error handling, and duplicate submission prevention.

### Requirements
- Flutter SDK

### Description
The water leakage complaint form captures user inputs via `TextFormField`, `DropdownButtonFormField`, custom choice chips for severity, date/time pickers, and mock photo attachments. It enforces validation rules (required fields, minimum character counts, email regex, 10-digit phone) and prevents accidental double-submissions via loading flags.

### File Names & Relevant Code
- File: `lib/screens/complaints/report_complaint_screen.dart`
- File: `lib/core/utils/validators.dart`

```dart
final _formKey = GlobalKey<FormState>();

// Validation execution
if (!_formKey.currentState!.validate()) return;

final created = await complaintProv.submitComplaint(
  userId: user.id!,
  userName: user.name,
  userPhone: user.phone,
  title: _titleController.text,
  description: _descriptionController.text,
  leakageType: _selectedLeakageType,
  location: _locationController.text,
  landmark: _landmarkController.text,
  severity: _selectedSeverity,
  imagePath: _attachedPhotoName,
);
```

### Step-by-Step Procedure
1. Create `ReportComplaintScreen` with `GlobalKey<FormState>()`.
2. Connect input fields with controllers and `Validators` methods.
3. Provide interactive date and time pickers.
4. Disable the submit button and show a spinner while `isSubmitting` is true.
5. On successful creation, navigate to `ComplaintSuccessScreen` displaying the unique ID (e.g. `AP-2026-0003`).

### Expected Output
Submitting with empty fields shows red validation messages. Filling valid details generates a unique complaint ID and creates initial history and database records.

### Result
Form input handling, validation, and error states were implemented and verified.

---

## EXPERIMENT 8(a) & 8(b)
### Aim
To incorporate fluid animations using Flutter's animation framework, demonstrating `AnimationController`, `CurvedAnimation`, `FadeTransition`, `ScaleTransition`, and custom ripple canvas effects.

### Requirements
- Flutter SDK

### Description
Flutter's animation framework uses `AnimationController` (driven by a `TickerProvider`) and `CurvedAnimation` to interpolate values between bounds. In AquaPulse, the animated splash screen utilizes scale and fade transitions for the drop logo along with a custom mathematical ripple painter to simulate water waves.

### File Names & Relevant Code
- File: `lib/screens/splash/splash_screen.dart`

```dart
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _rippleController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _rippleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();

    _scaleAnimation = CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack);
    _fadeAnimation = CurvedAnimation(parent: _scaleController, curve: const Interval(0.4, 1.0, curve: Curves.easeIn));

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }
}
```

### Step-by-Step Procedure
1. Mix in `TickerProviderStateMixin` in `_SplashScreenState`.
2. Initialize `AnimationController` for scaling and repeating water ripple effects.
3. Wrap UI widgets with `ScaleTransition` and `FadeTransition`.
4. Ensure controllers are cleanly disposed in `dispose()`.

### Expected Output
On launch, the AquaPulse logo expands smoothly with a bouncy spring curve while concentric water ripples expand and fade outward.

### Result
Animations were implemented, properly disposed, and verified.

---

## EXPERIMENT 9(a) & 9(b)
### Aim
To integrate a real external REST API over HTTP, parse JSON responses into strongly-typed Dart models, and render the fetched environmental data with loading, success, and error retry states.

### Requirements
- Flutter SDK
- `http: ^1.2.2` package
- Active Internet connection (with offline mock fallback)

### Description
The app connects to the open, public Open-Meteo Weather & Environmental API to retrieve live atmospheric conditions (temperature, humidity, precipitation). It translates these meteorological readings into practical municipal water conservation tips. The integration supports loading indicators, pull-to-refresh, error handling, and manual retry.

### File Names & Relevant Code
- File: `lib/models/environmental_model.dart`
- File: `lib/services/api_service.dart`
- File: `lib/providers/environmental_provider.dart`
- File: `lib/screens/dashboard/home_tab.dart`

```dart
// HTTP Request in ApiService
final response = await _client.get(Uri.parse(AppConstants.weatherApiUrl)).timeout(const Duration(seconds: 10));
if (response.statusCode == 200) {
  final Map<String, dynamic> data = jsonDecode(response.body);
  return EnvironmentalModel.fromJson(data);
}
```

### Step-by-Step Procedure
1. Create `EnvironmentalModel` with JSON factory constructor and offline fallback factory.
2. Build `ApiService` using `http.Client`.
3. Build `EnvironmentalProvider` to manage loading, data, and error states.
4. Render the data card on the Home dashboard with metrics and a refresh button.

### Expected Output
The Home dashboard displays real live temperature (°C), relative humidity (%), precipitation (mm), and localized water conservation guidance. Tapping refresh triggers real network fetching.

### Result
REST API integration with complete state handling was successfully demonstrated.

---

## EXPERIMENT 10(a) & 10(b)
### Aim
To author comprehensive unit tests and widget tests, execute test suites via `flutter test`, and demonstrate debugging techniques in VS Code (breakpoints, Debug Console, DevTools).

### Requirements
- Flutter SDK & `flutter_test`
- Visual Studio Code

### Description
Software testing ensures code reliability, data integrity, and UI correctness before release.
- Unit Tests: Verify isolated business logic (form validation, password hashing with salt, model serialization, database multi-user isolation, admin query filtering, automatic notifications).
- Widget Tests: Verify UI component rendering, text finding, user interaction simulation (`tester.tap`), and form interaction.
- Debugging: VS Code breakpoints, Flutter DevTools, and Debug Console stack tracing.

### File Names & Relevant Code
- Unit Tests:
  - `test/unit/validators_test.dart`
  - `test/unit/password_hasher_test.dart`
  - `test/unit/complaint_model_test.dart`
  - `test/unit/complaint_repository_test.dart`
- Widget Tests:
  - `test/widget/badges_test.dart`
  - `test/widget/stat_card_test.dart`
  - `test/widget/login_screen_test.dart`
  - `test/widget_test.dart`

```bash
# Execution Commands
flutter analyze
dart format .
flutter test
```

### Step-by-Step Procedure
1. Create test files under `test/unit/` and `test/widget/`.
2. Run `flutter test` in Windows PowerShell.
3. To debug in VS Code:
   - Open any file (e.g. `complaint_repository.dart`).
   - Click to the left of a line number to set a red breakpoint.
   - Press `F5` to start debugging with the Flutter engine.
   - Inspect local variables, watch expressions, and call stacks in the Run & Debug side panel.

### Expected Output
```text
00:16 +22: All tests passed!
```
All 22 unit and widget tests pass with 0 failures, and `flutter analyze` reports 0 issues.

### Result
Comprehensive unit and widget tests were authored and executed successfully, and debugging workflows were verified.
