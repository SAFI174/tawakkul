// Import necessary dependencies
import 'package:tawakkal/data/models/e_tasbih.dart';
import 'package:tawakkal/services/database_service.dart';

// Repository class for ElectronicTasbih
class ElectronicTasbihRepository {
  // Database service instance
  final DatabaseService _databaseService = DatabaseService('e_tasbih.db');

  // Table name for ElectronicTasbih
  static const String _tableName = 'e_tasbih';

  // Delete ElectronicTasbih by ID
  Future<void> deleteTasbih({required int id}) async {
    _databaseService.deleteData(tableName: _tableName, id: id);
  }

  // Update ElectronicTasbih
  Future<void> updateTasbih({
    required ElectronicTasbihModel electronicTasbihModel,
  }) async {
    await _databaseService.updateData(
      table: _tableName,
      values: electronicTasbihModel.toJson(),
      where: 'id = ?',
      whereArgs: [
        electronicTasbihModel.id,
      ],
    );
  }

// Update Counter ElectronicTasbih
  Future<void> updateCounters(
      {required ElectronicTasbihModel eTasbihModel}) async {
    await _databaseService.updateData(
      table: _tableName,
      values: {
        'counter': eTasbihModel.counter.value,
        'total_counter': eTasbihModel.totalCounter.value,
      },
      where: 'id = ?',
      whereArgs: [
        eTasbihModel.id,
      ],
    );
  }

  Future<void> resetCounter({required int id}) async {
    await _databaseService.updateData(
      table: _tableName,
      values: {
        'counter': 0,
        'total_counter': 0,
      },
      where: 'id =?',
      whereArgs: [
        id,
      ],
    );
  }
  // Insert ElectronicTasbih
  Future<void> insertTasbih({
    required ElectronicTasbihModel electronicTasbihModel,
  }) async {
    await _databaseService.insertData(
      tableName: _tableName,
      data: electronicTasbihModel.toJson(),
    );
  }

  // Get all ElectronicTasbih
  Future<List<ElectronicTasbihModel>> getAllTasbih() async {
    // Read data from the database
    List<Map<String, dynamic>> maps =
        await _databaseService.readData(tableName: _tableName);

    // Map data to list of ElectronicTasbihModel
    return maps.map((e) => ElectronicTasbihModel.fromJson(e)).toList();
  }
}
