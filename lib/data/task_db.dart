import 'package:smart_todoapp/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:smart_todoapp/models/task.dart';

class TaskDb {
  static final TaskDb _instance = TaskDb._internal();
  factory TaskDb() => _instance;
  TaskDb._internal();

  Database? _dbClient;

  /// Initialize db reference
  Future<void> init() async {
    _dbClient ??= await DatabaseHelper().db;
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER,
        time TEXT,
        created_at TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL,
        priority INTEGER NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertTask(Task task) async {
    final db = _dbClient ?? await DatabaseHelper().db;
    return await db.insert('tasks', task.toMap());
  }

  // READ
  Future<List<Task>> getAllTasks() async {
    final db = _dbClient ?? await DatabaseHelper().db;
    final List<Map<String, dynamic>> result = await db.query('tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateTask(Task task) async {
    final db = _dbClient ?? await DatabaseHelper().db;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<int> deleteTask(int id) async {
    final db = _dbClient ?? await DatabaseHelper().db;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // DELETE ALL
  Future<void> clearAllTasks() async {
    final db = _dbClient ?? await DatabaseHelper().db;
    await db.delete('tasks');
  }
}
