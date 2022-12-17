import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';

class CategoriesService extends FirebaseService {
  CategoriesService([AuthToken? authToken]) : super(authToken);

  Future<List<CategoryModel>> fetchCategories(
      [bool filterByUser = false]) async {
    final List<CategoryModel> Categories = [];

    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final CategoriesUrl =
          Uri.parse('$databaseUrl/categories.json?auth=$token&$filters');
      final response = await http.get(CategoriesUrl);
      final CategoriesMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(CategoriesMap['error']);
        return Categories;
      }
     

      final userFavoritesUrl =
          Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      CategoriesMap.forEach((categoryId, category) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[categoryId] ?? false);
        Categories.add(
          CategoryModel.fromJson({
            'id': categoryId,
            ...category,
          }).copyWith(),
        );
      });
      return Categories;
    } catch (error) {
      print(error);
      return Categories;
    }
  }

  Future<CategoryModel?> addCategory(CategoryModel category) async {
    try {
      final url = Uri.parse('$databaseUrl/categories.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          category.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return category.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    try {
      final url =
          Uri.parse('$databaseUrl/categories/${category.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(category.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/categories/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
