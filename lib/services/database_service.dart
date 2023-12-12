import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class DatabaseService extends GetxController {
  late Database _database;

  late String databaseName;

  DatabaseService(this.databaseName);

  Future<void> initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, databaseName);
    if (!(await File(path).exists())) {
      await _copyDatabaseFromAssets(path: path);
    }
    // Open the database
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // create your tables here if needed
    });
  }

  Future<void> _copyDatabaseFromAssets({required String path}) async {
    ByteData data = await rootBundle.load("assets/databases/$databaseName");
    List<int> bytes =
        data.buffer.asUint8List(); // Convert the ByteData to a list of bytes

    // Write the bytes to the database file
    await File(path).writeAsBytes(bytes, flush: true);
  }

  // Insert data into the database
  Future<void> insertData(
      {required String tableName, required Map<String, dynamic> data}) async {
    await initDatabase();

    await _database.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    update(); // Notify GetX that the data has changed
  }

  // Delete data from the database
  Future<void> deleteData({required String tableName, required int id}) async {
    await initDatabase();
    await _database.delete(tableName, where: 'id = ?', whereArgs: [id]);
    update(); // Notify GetX that the data has changed
  }

  Future<List<Map<String, dynamic>>> queryData({required String query}) async {
    await initDatabase();
    return await _database.rawQuery(query);
  }

  // Read data from the database
  Future<List<Map<String, dynamic>>> readData(
      {required String tableName,
      String? where,
      List<Object>? whereArgs}) async {
    await initDatabase();
    return await _database.query(tableName, where: where, whereArgs: whereArgs);
  }

  // Update data from the database
  Future<int> updateDataQuery({required String query}) async {
    await initDatabase();
    return await _database.rawUpdate(query);
  }

  // Update data from the database
  Future<int> updateData(
      {required String table,
      required Map<String, dynamic> values,
      String? where,
      List<dynamic>? whereArgs}) async {
    await initDatabase();
    return await _database.update(table, values,
        where: where, whereArgs: whereArgs);
  }
}
