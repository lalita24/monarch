import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/monarch.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'monarchs.db';
  static const _dbVersion = 1;
  static const table = 'monarchs';

  static const colId = 'id';
  static const colReignNo = 'reignNo';
  static const colName = 'name';
  static const colYears = 'years';
  static const colBio = 'bio';
  static const colPhoto = 'photoPath';

  Database? _db;
  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colReignNo INTEGER NOT NULL,
        $colName TEXT NOT NULL,
        $colYears TEXT NOT NULL,
        $colBio TEXT NOT NULL,
        $colPhoto TEXT NOT NULL
      )
    ''');

    // สร้างข้อมูลเริ่มต้น ร.1–ร.10
    final defaults = List.generate(10, (i) {
      final n = i + 1;
      return Monarch(
        reignNo: n,
        name: 'รัชกาลที่ $n',
        years: '',
        bio: 'เพิ่มข้อมูลประวัติย่อที่นี่',
        photoPath: 'assets/images/r$n.jpg',
      ).toMap();
    });
    final batch = db.batch();
    for (final m in defaults) {
      batch.insert(table, m);
    }
    await batch.commit(noResult: true);
  }

  // CRUD
  Future<int> insertMonarch(Monarch m) async {
    final db = await database;
    return db.insert(table, m.toMap());
  }

  Future<List<Monarch>> getAllMonarchs() async {
    final db = await database;
    final maps = await db.query(table, orderBy: '$colReignNo ASC');
    return maps.map((e) => Monarch.fromMap(e)).toList();
  }

  Future<int> updateMonarch(Monarch m) async {
    final db = await database;
    return db.update(
      table,
      m.toMap(),
      where: '$colId = ?',
      whereArgs: [m.id],
    );
  }

  Future<int> deleteMonarch(int id) async {
    final db = await database;
    return db.delete(table, where: '$colId = ?', whereArgs: [id]);
  }
}
