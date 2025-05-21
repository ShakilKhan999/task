import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_noti/models/alarm_model.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'alarms_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alarms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateTime TEXT NOT NULL,
        isActive INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertAlarm(Alarm alarm) async {
    Database db = await database;
    return await db.insert('alarms', alarm.toMap());
  }

  Future<List<Alarm>> getAlarms() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alarms');
    return List.generate(maps.length, (i) {
      return Alarm.fromMap(maps[i]);
    });
  }

  Future<int> updateAlarm(Alarm alarm) async {
    Database db = await database;
    return await db.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }
}
