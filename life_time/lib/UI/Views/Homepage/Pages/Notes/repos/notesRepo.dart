import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CRUDINNotes {
  static final CRUDINNotes instance = CRUDINNotes._init();
  static Database? _database;

  CRUDINNotes._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        deadline TEXT NOT NULL,
        isChecked INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> addNote(Map<String, dynamic> note) async {
    final db = await instance.database;

    return await db.insert('notes', note);
  }

  Future<List<Map<String, dynamic>>> retrieveNotes() async {
    final db = await instance.database;
    return await db.query('notes');
  }

  Future<List<Map<String, dynamic>>> retriveNotesOfCurrentDate() async {
    final db = await instance.database;

    String today = DateTime.now().toString().split(' ')[0];

    return await db.query('notes', where: "deadline = ?", whereArgs: [today]);
  }

  Future<int> toggleIsChecked(int id, bool isChecked) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      {'isChecked': isChecked ? 1 : 0}, // Convert boolean to integer (1 or 0)
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}

CRUDINNotes db = CRUDINNotes._init();
