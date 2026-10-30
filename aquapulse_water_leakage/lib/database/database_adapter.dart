/// Common interface for database operations across platforms.
/// Enables seamless operation on Android (via SQLite/sqflite) as well as
/// Web/Desktop environments without native binary crashes.
abstract class DatabaseAdapter {
  Future<void> init();

  Future<int> insert(String table, Map<String, dynamic> values);

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  });

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]);

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs});

  Future<void> close();
}
