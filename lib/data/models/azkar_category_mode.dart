class AzkarCategoryModel {
  int? id;
  String title; // Assuming name is a String, adjust the type accordingly
  bool isAddedByUser;

  AzkarCategoryModel({
    this.id,
    required this.title,
    required this.isAddedByUser,
  });

  // Convert a JSON object to an AzkarCategoryModel instance
  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AzkarCategoryModel(
      id: json['id'] as int,
      title: json['title'] as String,
      isAddedByUser: json['isAddedByUser'] == 0 ? false : true,
    );
  }

  // Convert an AzkarCategoryModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isAddedByUser': isAddedByUser,
    };
  }
}
