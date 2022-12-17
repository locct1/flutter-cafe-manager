import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/total_expense.dart';
import '../models/auth_token.dart';
import 'firebase_service.dart';

class TotalExpensesService extends FirebaseService {
  TotalExpensesService([AuthToken? authToken]) : super(authToken);

  Future<List<TotalExpense>> fetchTotalExpenses(
      [bool filterByUser = false]) async {
    final List<TotalExpense> TotalExpenses = [];

    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final TotalExpensesUrl =
          Uri.parse('$databaseUrl/totalexpenses.json?auth=$token&$filters');
      final response = await http.get(TotalExpensesUrl);
      final TotalExpensesMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(TotalExpensesMap['error']);
        return TotalExpenses;
      }
      final userFavoritesUrl =
          Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      TotalExpensesMap.forEach((categoryId, category) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[categoryId] ?? false);
        TotalExpenses.add(
          TotalExpense.fromJson({
            'id': categoryId,
            ...category,
          }).copyWith(),
        );
      });
      return TotalExpenses;
    } catch (error) {
      print(error);
      return TotalExpenses;
    }
  }

  Future<TotalExpense?> addTotalExpense(TotalExpense category) async {
    try {
       
      final url = Uri.parse('$databaseUrl/totalexpenses.json?auth=$token');
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

  Future<bool> updateTotalExpense(TotalExpense category) async {
    try {
      final url =
          Uri.parse('$databaseUrl/totalexpenses/${category.id}.json?auth=$token');
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

  Future<bool> deleteTotalExpense(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/totalexpenses/$id.json?auth=$token');
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
