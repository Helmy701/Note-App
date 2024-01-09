import 'package:waelfirebase/constants/constants.dart';

class CategoryModel {
  final String userID;
  final String name;
  final String categoryID;

  CategoryModel({
    required this.userID,
    required this.name,
    required this.categoryID,
  });
  factory CategoryModel.fromJson(json) {
    return CategoryModel(
      userID: json[kUserId],
      name: json[kCategoryName],
      categoryID: json[kCategoryID],
    );
  }
}
