import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'database_adapter.dart';
import 'mobile_database_adapter.dart';
import 'web_memory_database_adapter.dart';

/// AppDatabase singleton factory.
/// Automatically detects platform:
/// - Android / iOS: Uses real SQLite storage via MobileDatabaseAdapter
/// - Web / Windows / Test: Uses zero-native-dependency WebMemoryDatabaseAdapter
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  DatabaseAdapter? _adapter;

  DatabaseAdapter get adapter {
    if (_adapter == null) {
      throw StateError(
        'AppDatabase has not been initialized. Call AppDatabase().init() in main().',
      );
    }
    return _adapter!;
  }

  Future<void> init({DatabaseAdapter? customAdapter}) async {
    if (_adapter != null) return;

    if (customAdapter != null) {
      _adapter = customAdapter;
    } else if (kIsWeb) {
      _adapter = WebMemoryDatabaseAdapter();
    } else {
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          _adapter = MobileDatabaseAdapter();
        } else {
          // Windows / Linux / macOS desktop or headless test runner
          _adapter = WebMemoryDatabaseAdapter();
        }
      } catch (_) {
        _adapter = WebMemoryDatabaseAdapter();
      }
    }

    await _adapter!.init();
  }

  Future<void> close() async {
    await _adapter?.close();
    _adapter = null;
  }
}
