import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbHelper {
  static final LocalDbHelper instance = LocalDbHelper._internal();
  static Database? _database;

  LocalDbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sapi_madura_offline.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabel Riwayat Profil Sapi
    await db.execute('''
      CREATE TABLE cattle (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tag_number TEXT NOT NULL UNIQUE,
        name TEXT,
        initial_weight REAL NOT NULL,
        entry_age_months INTEGER NOT NULL,
        gender TEXT NOT NULL,
        feed_type TEXT NOT NULL,
        daily_feed_amount REAL NOT NULL,
        feed_frequency INTEGER NOT NULL,
        health_condition TEXT NOT NULL,
        vaccination_status TEXT NOT NULL,
        target_weight REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabel Log Penimbangan Berkala (Record ADG di kandang)
    await db.execute('''
      CREATE TABLE weight_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cattle_id INTEGER NOT NULL,
        recorded_date TEXT NOT NULL,
        recorded_weight REAL NOT NULL,
        adg REAL,
        notes TEXT,
        FOREIGN KEY (cattle_id) REFERENCES cattle (id) ON DELETE CASCADE
      )
    ''');

    // Tabel Hasil Prediksi Panen (Riwayat inferensi)
    await db.execute('''
      CREATE TABLE prediction_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cattle_id INTEGER,
        cattle_tag TEXT,
        initial_weight REAL NOT NULL,
        target_weight REAL NOT NULL,
        predicted_adg REAL NOT NULL,
        estimated_days INTEGER NOT NULL,
        estimated_harvest_date TEXT NOT NULL,
        feed_type TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCattle(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('cattle', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllCattle() async {
    final db = await database;
    return await db.query('cattle', orderBy: 'id DESC');
  }

  Future<int> insertPrediction(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('prediction_history', row);
  }

  Future<List<Map<String, dynamic>>> getPredictionHistory() async {
    final db = await database;
    return await db.query('prediction_history', orderBy: 'id DESC');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

