import 'package:flutter/foundation.dart';
import '../../models/category.dart';
import '../../models/auth_token.dart';
import '../../services/categories_service.dart';

class CategoriesManager with ChangeNotifier {
  List<CategoryModel> _items = [];
  final CategoriesService _categoriesService;

  CategoriesManager([AuthToken? authToken])
      : _categoriesService = CategoriesService(authToken);

  set authToken(AuthToken? authToken) {
    _categoriesService.authToken = authToken;
  }

  Future<void> fetchCategories([bool filterByUser = false]) async {
    _items = await _categoriesService.fetchCategories(filterByUser);
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel categories) async {
    final newCategory = await _categoriesService.addCategory(categories);
    if (newCategory != null) {
      _items.add(newCategory);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<CategoryModel> get items {
    return [..._items];
  }

  CategoryModel findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateCategory(CategoryModel categories) async {
    final index = _items.indexWhere((item) => item.id == categories.id);
    if (index >= 0) {
      if (await _categoriesService.updateCategory(categories)) {
        _items[index] = categories;
        notifyListeners();
      }
    }
  }

  Future<void> deleteCategory(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    CategoryModel? existingCategory = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _categoriesService.deleteCategory(id)) {
      _items.insert(index, existingCategory);
      notifyListeners();
    }
  }
}
