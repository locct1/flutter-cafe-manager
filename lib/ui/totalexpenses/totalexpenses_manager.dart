import 'package:flutter/foundation.dart';
import '../../models/total_expense.dart';
import '../../models/auth_token.dart';
import '../../services/totalexpenses_service.dart';

class TotalExpensesManager with ChangeNotifier {
  List<TotalExpense> _items = [];
  final TotalExpensesService _totalexpensesService;

  TotalExpensesManager([AuthToken? authToken])
      : _totalexpensesService = TotalExpensesService(authToken);

  set authToken(AuthToken? authToken) {
    _totalexpensesService.authToken = authToken;
  }

  Future<void> fetchTotalExpenses([bool filterByUser = false]) async {
    _items = await _totalexpensesService.fetchTotalExpenses(filterByUser);
    notifyListeners();
  }

  Future<void> addTotalExpense(TotalExpense totalexpenses) async {
    totalexpenses = totalexpenses.copyWith(dateTime: DateTime.now());
    final newTotalExpense =
        await _totalexpensesService.addTotalExpense(totalexpenses);
    if (newTotalExpense != null) {
      _items.add(newTotalExpense);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<TotalExpense> get items {
    return [..._items];
  }

  TotalExpense findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateTotalExpense(TotalExpense totalexpenses) async {
    final index = _items.indexWhere((item) => item.id == totalexpenses.id);
    if (index >= 0) {
      if (await _totalexpensesService.updateTotalExpense(totalexpenses)) {
        _items[index] = totalexpenses;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTotalExpense(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    TotalExpense? existingTotalExpense = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _totalexpensesService.deleteTotalExpense(id)) {
      _items.insert(index, existingTotalExpense);
      notifyListeners();
    }
  }

  double get totalAmount {
    var total = 0.0;
    for (var order in _items) {
      total += order.price;
    }
    return total;
  }
}
