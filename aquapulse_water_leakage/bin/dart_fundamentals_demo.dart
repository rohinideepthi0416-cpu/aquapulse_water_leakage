// ignore_for_file: avoid_print
/// College Practical Experiment 1(b)
/// Demonstrates Variables, Data Types, Operators, Conditions, Loops, Functions, and Collections.
void main() {
  print('====================================================');
  print('    AQUAPULSE - EXPERIMENT 1(b): DART FUNDAMENTALS   ');
  print('====================================================');

  // 1. Variables and Data Types
  final String appTitle = 'AquaPulse Water Leakage Management';
  int reportedLeaks = 42;
  double averageRepairHours = 3.5;
  bool isAlertActive = true;
  num waterLitersSaved = 12500.75;

  print('\n[1] VARIABLES & DATA TYPES:');
  print('App Title (String): $appTitle');
  print('Reported Leaks (int): $reportedLeaks');
  print('Average Repair Time (double): $averageRepairHours hours');
  print('System Alert Active (bool): $isAlertActive');
  print('Water Saved (num): $waterLitersSaved Litres');

  // 2. Operators (Arithmetic, Relational, Logical)
  final int pendingComplaints = 14;
  final int resolvedComplaints = reportedLeaks - pendingComplaints;
  final double resolutionPercentage =
      (resolvedComplaints / reportedLeaks) * 100;
  final bool hasCriticalBacklog = pendingComplaints > 10 && isAlertActive;

  print('\n[2] OPERATORS:');
  print('Resolved Complaints: $resolvedComplaints');
  print('Resolution Percentage: ${resolutionPercentage.toStringAsFixed(1)}%');
  print('Critical Backlog Status (Logical AND): $hasCriticalBacklog');

  // 3. Conditional Statements (if-else, switch-case)
  print('\n[3] CONDITIONS:');
  String severity = 'Critical';
  if (severity == 'Critical') {
    print('Immediate dispatch required: Field crew response within 1 hour.');
  } else if (severity == 'High') {
    print('Urgent response: Field crew response within 4 hours.');
  } else {
    print('Standard municipal maintenance queue.');
  }

  // 4. Collections: List, Set, Map
  print('\n[4] COLLECTIONS:');
  final List<String> leakageCategories = [
    'Pipeline Leak',
    'Overflowing Tank',
    'Broken Public Tap',
    'Drainage Leak',
  ];
  print('Categories (List): $leakageCategories');

  // Demonstrating deduplication in sets using .toSet()
  final List<String> recordedWards = ['Ward 4', 'Ward 12', 'Ward 4', 'Ward 18'];
  final Set<String> uniqueWards = recordedWards.toSet();
  print('Recorded Wards (List with duplicate): $recordedWards');
  print('Unique Wards (Set deduplicated): $uniqueWards');

  final Map<String, int> severityCount = {
    'Critical': 8,
    'High': 12,
    'Medium': 15,
    'Low': 7,
  };
  print('Complaints by Severity (Map): $severityCount');

  // 5. Loops (for, for-in, while)
  print('\n[5] LOOPS:');
  print('Iterating through categories:');
  for (int i = 0; i < leakageCategories.length; i++) {
    print('  ${i + 1}. ${leakageCategories[i]}');
  }

  print('\nIterating severity breakdown:');
  for (var entry in severityCount.entries) {
    print('  - ${entry.key}: ${entry.value} reports');
  }

  // 6. Functions (Named, Positional, Higher-order)
  print('\n[6] FUNCTIONS:');
  final double efficiency = calculateEfficiencyScore(
    total: reportedLeaks,
    resolved: resolvedComplaints,
    benchmarkScore: 90.0,
  );
  print('Maintenance Efficiency Score: $efficiency / 100');

  print('====================================================');
}

/// Helper function demonstrating named parameters and return type
double calculateEfficiencyScore({
  required int total,
  required int resolved,
  double benchmarkScore = 100.0,
}) {
  if (total == 0) return 0.0;
  final ratio = resolved / total;
  return ratio * benchmarkScore;
}
