import '../model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;
  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb('notes.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    // TABLE TYPE IN SQL
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    // CREATE TABLE
    await db.execute('''
    CREATE TABLE $tableNotes(
      ${NoteFields.id} $idType,
      ${NoteFields.noteTitle} $textType,
      ${NoteFields.noteDescription} $textType,
      ${NoteFields.createdTime} $textType,
      ${NoteFields.chooseColorIndex} $integerType
    )
    ''');
  }

  Future<Note> createNote(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());

    return note.copyWith(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        // this two comments are more secured for sql injections attack
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.createdTime} ASC';

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((note) => Note.fromJson(note)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(tableNotes, note.toJson(), where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return db.delete(tableNotes, where: '${NoteFields.id}=?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
