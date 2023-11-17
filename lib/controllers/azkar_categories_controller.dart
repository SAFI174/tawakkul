import 'package:get/get.dart';
import 'package:tawakkal/data/models/azkar_muslim_category_mode.dart';
import 'package:tawakkal/data/repository/azkar_repository.dart';

class AzkarCategoriesController extends GetxController {
  late Future<List<AzkarCategoryModel>> futureAzkarCategories;
  late final AzkarRepository azkarRepository;
  @override
  void onInit() async {
    super.onInit();
    azkarRepository = AzkarRepository();
    futureAzkarCategories = azkarRepository.getAzkarCategories();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
