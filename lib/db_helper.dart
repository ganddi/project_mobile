import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'spotify_clone_v2.db'); // Ganti nama file biar fresh
    
    return await openDatabase(
      path,
      version: 1, // Kita mulai dari versi 1 lagi tapi dengan nama file baru
      onCreate: (db, version) async {
        print("--- MEMBUAT TABEL BARU ---");
        await db.execute(
          'CREATE TABLE playlists(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, subtitle TEXT)',
        );
      },
    );
  }

  Future<int> insertPlaylist(Map<String, dynamic> row) async {
    Database db = await database;
    try {
      int id = await db.insert('playlists', row);
      print("--- DATA BERHASIL DISIMPAN ID: $id ---"); // Log sukses
      return id;
    } catch (e) {
      print("--- ERROR SAAT INSERT: $e ---"); // Log error
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    Database db = await database;
    try {
      var result = await db.query('playlists');
      print("--- DATA DIAMBIL: ${result.length} item ---");
      return result;
    } catch (e) {
      print("--- ERROR SAAT GET: $e ---");
      return [];
    }
  }

Future<int> deletePlaylist(int id) async {
    final db = await database;
    return await db.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

Future<int> updatePlaylist(int id, String newTitle) async {
    final db = await database;
    return await db.update(
      'playlists',
      {'title': newTitle}, // Kolom yang diubah
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}



