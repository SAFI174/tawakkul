import 'package:enum_to_string/enum_to_string.dart';
import 'package:tawakkal/constants/enum.dart';
import 'package:tawakkal/data/models/azkar_category_mode.dart';
import 'package:tawakkal/data/models/azkar_detail_model.dart';
import 'package:tawakkal/utils/dialogs/dialogs.dart';

import '../../services/database_service.dart';

class AzkarRepository {
  final DatabaseService _databaseService = DatabaseService('azkar.db');
  static const String _categoryTable = 'azkar_category';
  static const String _azkarDetailsTable = 'azkar_details';

  // Fetch Azkar categories from the database
  Future<List<AzkarCategoryModel>> getAzkarCategories() async {
    // Retrieve data from the category table
    final data = await _databaseService.readData(tableName: _categoryTable);
    // Map the data to AzkarCategoryModel and return the list
    return data.map((e) => AzkarCategoryModel.fromJson(e)).toList();
  }

  // Reset counters for a specific Azkar type
  Future<void> resetCountersForType({required AzkarPageType zkrType}) async {
    // Update Azkar details table to reset counters for the specified type
    await _databaseService.updateDataQuery(
      query:
          "UPDATE $_azkarDetailsTable set counter = count, isDone = 0 where zkr_type = '${EnumToString.convertToString(zkrType)}'",
    );
  }

  Future<void> resetCountersForCategoryId({required int categoryId}) async {
    // Update Azkar details table to reset counters for the specified type
    await _databaseService.updateDataQuery(
      query:
          "UPDATE $_azkarDetailsTable set counter = count, isDone = 0 where  categoryId = $categoryId",
    );
  }

  Future<void> saveAzkarProgress({
    required List<AzkarDetailModel> data,
  }) async {
    // Iterate through the list and update the database for each Azkar detail
    for (var azkarDetail in data) {
      await _databaseService.updateData(
        table: _azkarDetailsTable,
        values: {
          'counter': azkarDetail.counter,
          'isDone': azkarDetail.isDone ? 1 : 0,
        }, // Assuming toJson returns a Map<String, dynamic>
        where: 'id = ?', // Adjust the condition based on your data structure
        whereArgs: [
          azkarDetail.id,
        ], // Pass the appropriate identifier
      );
    }
  }

  // Get Azkar details by type, considering previous progress
  Future<List<AzkarDetailModel>> getAzkarByType({
    required AzkarPageType zkrType,
  }) async {
    // Fetch Azkar details from the database based on the specified type
    var azkarData = await _fetchAzkarDataByType(zkrType);

    // Check if there is previous progress
    if (_hasPreviousProgress(azkarData)) {
      // Show dialog to ask if the user wants to continue from previous progress
      bool continueFromProgress = await showZkrProgressFoundForContinue() ?? false;
      if (continueFromProgress) {
        return azkarData; // Return the existing data
      } else {
        // Reset counters if the user chooses not to continue
        await resetCountersForType(zkrType: zkrType);
        // Fetch Azkar details again after resetting counters
        azkarData = await _fetchAzkarDataByType(zkrType);
      }
    }
    return azkarData;
  }

  // Fetch Azkar details by type from the database
  Future<List<AzkarDetailModel>> _fetchAzkarDataByType(
      AzkarPageType zkrType) async {
    var data = await _databaseService.readData(
      tableName: _azkarDetailsTable,
      where: 'zkr_type =?',
      whereArgs: [EnumToString.convertToString(zkrType)],
    );
    // Map the data to AzkarDetailModel and return the list
    return data.map((e) => AzkarDetailModel.fromJson(e)).toList();
  }

  // Check if there is previous progress for Azkar
  bool _hasPreviousProgress(List<AzkarDetailModel> azkarData) {
    return azkarData
        .any((element) => element.counter < element.count || element.isDone);
  }

// Fetch Azkar details by type from the database
  Future<List<AzkarDetailModel>> _fetchAzkarDataByCategoryId(
      int categoryId) async {
    final data = await _databaseService.readData(
        tableName: _azkarDetailsTable,
        where: 'categoryId =?',
        whereArgs: [categoryId]);
    // Map the data to AzkarDetailModel and return the list
    return data.map((e) => AzkarDetailModel.fromJson(e)).toList();
  }

  // Get Azkar details by category ID from the database
  Future<List<AzkarDetailModel>> getAzkarByCategoryId(
      {required categoryId}) async {
    var azkarData = await _fetchAzkarDataByCategoryId(categoryId);
    // Check if there is previous progress
    if (_hasPreviousProgress(azkarData)) {
      // Show dialog to ask if the user wants to continue from previous progress
      bool continueFromProgress = await showZkrProgressFoundForContinue() ?? false;
      if (continueFromProgress) {
        return azkarData; // Return the existing data
      } else {
        // Reset counters if the user chooses not to continue
        await resetCountersForCategoryId(categoryId: categoryId);
        // Fetch Azkar details again after resetting counters
        azkarData = await _fetchAzkarDataByCategoryId(categoryId);
      }
    }
    return azkarData; // Return the existing data
  }
}
