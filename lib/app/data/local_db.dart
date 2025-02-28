import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  Future<Database> createDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'attendance.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE attendance (
            entryId INTEGER PRIMARY KEY AUTOINCREMENT, 
            employeeName TEXT, 
            empId TEXT, 
            designation TEXT, 
            punchStatus TEXT, 
            time TEXT, 
            date TEXT, 
            imageJpg BLOB
          )
        ''');
      },
    );

    return database;
  }

  Future<Map<String, dynamic>?> getLastPunch(String empId, String date) async {
    final db = await createDB();
    List<Map<String, dynamic>> result = await db.query(
      'attendance',
      where: 'empId = ? AND date = ?',
      whereArgs: [empId, date],
      orderBy: 'entryId DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> addData({
    required String employeeName,
    required String empId,
    required String designation,
    required String punchStatus,
    required String time,
    required String date,
    required Uint8List imageJpg,
  }) async {
    final db = await createDB();

    return await db.insert(
      'attendance',
      {
        'employeeName': employeeName,
        'empId': empId,
        'designation': designation,
        'punchStatus': punchStatus,
        'time': time,
        'date': date,
        'imageJpg': imageJpg,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceLog() async {
    final db = await createDB();
    return await db.query('attendance', orderBy: 'entryId DESC');
  }
}
