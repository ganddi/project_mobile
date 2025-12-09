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
    String path = join(await getDatabasesPath(), 'spotify_clone.db');
    
    // GANTI VERSION JADI 2 (Supaya memaksa update jika tidak uninstall)
    return await openDatabase(
      path,
      version: 2, 
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE playlists(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, subtitle TEXT)',
        );
      },
      // Tambahkan onUpgrade untuk jaga-jaga
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
           db.execute('CREATE TABLE playlists(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, subtitle TEXT)');
        }
      },
    );
  }

  Future<int> insertPlaylist(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('playlists', row);
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    Database db = await database;
    return await db.query('playlists');
  }
}