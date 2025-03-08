import 'dart:convert';

import 'package:tadween_app/core/error/exceptions.dart';
import 'package:tadween_app/core/server/data_base.dart';
import 'package:tadween_app/features/category/data/models/category_model.dart';
import 'package:http/http.dart' as http;

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<String> addCategory(CategoryModel categoryModel);
}

class CategoriesRemoteDataSourceImplementation
    extends CategoriesRemoteDataSource {
  @override
  Future<String> addCategory(CategoryModel categoryModel) async {
    final url = Uri.https(DATA_BASE_URL, '/categories.json');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': categoryModel.name,
        'iconName': CategoryModel.getIconFromString(categoryModel.icon),
      }),
    );

    json.decode(response.body);

    var responseData = json.decode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final String categoryId = responseData['name'];
      return categoryId;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final List<CategoryModel> categories = [];

    final url = Uri.https(DATA_BASE_URL, '/categories.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = response.body.isNotEmpty ? json.decode(response.body) : {};
      if (body is! Map<String, dynamic>) {
        throw ServerException();
      }

      for (final category in body.entries) {
        categories.add(
          CategoryModel.remoteSource(
            iconName: category.value['iconName'] ?? '',
            id: category.key,
            name: category.value['name'] ?? '',
          ),
        );
      }
    } else {
      throw ServerException();
    }

    return categories;
  }
}
