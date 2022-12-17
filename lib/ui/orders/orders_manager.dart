import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../models/cart_item.dart';
import '../../models/order_detail.dart';
import '../../models/order_item.dart';
import '../../services/orders_service.dart';
import '../../models/auth_token.dart';
import '../../models/product.dart';
import 'package:intl/intl.dart';

class OrdersManager with ChangeNotifier {
  List<OrderItem> _orders = [];
  final OrderItemsService _orderItemsService;

  OrdersManager([AuthToken? authToken])
      : _orderItemsService = OrderItemsService(authToken);

  set authToken(AuthToken? authToken) {
    _orderItemsService.authToken = authToken;
  }

  Future<void> fetchOrderItems([bool filterByUser = false]) async {
    _orders = await _orderItemsService.fetchOrderItems(filterByUser);
    _orders = _orders.reversed.toList();
    notifyListeners();
  }

  OrderItem findById(String id) {
    return _orders.firstWhere((prod) => prod.id == id);
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total,
      int tableNumber, String note) async {
    final List<OrderDetail> _orderdetail = [];
    cartProducts.forEach((product) {
      _orderdetail.insert(
        0,
        OrderDetail(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity: product.quantity,
          imageUrl: product.imageUrl,
        ),
      );
    });
    final _orderitem = OrderItem(
      id: null,
      amount: total,
      tableNumber: tableNumber,
      note: note,
      status: '0',
      products: _orderdetail,
      dateTime: DateTime.now(),
    );
    final newOrderItem = await _orderItemsService.addOrderItem(_orderitem);
    if (newOrderItem != null) {
      _orders.insert(0, newOrderItem);
    }
    notifyListeners();
  }

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  double orderAmount(OrderItem order) {
    double total = 0;
    for (var item in _orders) {
      if (order.id == item.id) {
        total = item.amount;
      }
    }
    return total;
  }

  Future<void> updateOrderForm(OrderItem order) async {
    print(1);
    final index = _orders.indexWhere((item) => item.id == order.id);
    if (index >= 0) {
      if (await _orderItemsService.updateOrderForm(order)) {
        _orders[index] = _orders[index]
            .copyWith(tableNumber: order.tableNumber, note: order.note);
        notifyListeners();
      }
    }
  }

  List<OrderItem> orderUnPaid() {
    return _orders.where((orderItem) => orderItem.status == '0').toList();
  }

  List<OrderItem> Paid() {
    return _orders.where((orderItem) => orderItem.status == '1').toList();
  }

  Future<void> confirmCheckOut(OrderItem order) async {
    order = order.copyWith(status: '1');
    if (!await _orderItemsService.confirmCheckOut(order)) {}
    notifyListeners();
  }

  int findQuantity(Product product, OrderItem order) {
    int quantity = 0;
    for (var item in order.products) {
      if (product.id == item.id) {
        quantity = item.quantity;
      }
    }
    return quantity;
  }

  Future<void> removeSingleItem(String productId, OrderItem order) async {
    final index = _orders.indexWhere((item) => item.id == order.id);
    for (var i = 0; i < order.products.length; i++) {
      if (order.products[i].id == productId) {
        if (order.products[i].quantity as num > 1) {
          order.products[i] = order.products[i]
              .copyWith(quantity: order.products[i].quantity - 1);
        } else {
          order.products.removeWhere((item) => item.id == productId);
        }
      }
    }
      double total = 0;
    for (var product in order.products) {
      total += product.price * product.quantity;
    }
    order = order.copyWith(amount: total);
    if (index >= 0) {
      if (await _orderItemsService.updateOrder(order)) {
        _orders[index] = order;
      }
    }
    notifyListeners();
  }

  Future<void> addItem(Product product, OrderItem order) async {
    final index = _orders.indexWhere((item) => item.id == order.id);
    final indexProduct =
        order.products.indexWhere((item) => item.id == product.id);
    if (indexProduct >= 0) {
      order.products[indexProduct] = order.products[indexProduct]
          .copyWith(quantity: order.products[indexProduct].quantity + 1);
    } else {
      final orderDetail = OrderDetail(
          id: product.id.toString(),
          title: product.title.toString(),
          quantity: 1,
          price: product.price,
          imageUrl: product.imageUrl);
      order.products.add(orderDetail);
    }
    double total = 0;
    for (var product in order.products) {
      total += product.price * product.quantity;
    }
    order = order.copyWith(amount: total);
    if (index >= 0) {
      if (await _orderItemsService.updateOrder(order)) {
        _orders[index] = order;
      }
    }
    notifyListeners();
  }
  double get totalAmount {
    var total = 0.0;
    for (var order in _orders) {
      total += order.amount;
    }
    return total;
  }
}
// class OrdersManager with ChangeNotifier {
//   final List<OrderItem> _orders = [];
//   final OrderItemsService _orderItemsService;

//   OrdersManager([AuthToken? authToken])
//       : _orderItemsService = OrderItemsService(authToken);

//   set authToken(AuthToken? authToken) {
//     _orderItemsService.authToken = authToken;
//   }
//   int get orderCount {
//     return _orders.length;
//   }


//   List<OrderItem> get orders {
//     return [..._orders];
//   }

//   Future<void> addOrder(
//       List<CartItem> cartProducts, double total, int tableNumber) async {
//     final List<OrderDetail> _orderdetail = [];
//     cartProducts.forEach((product) {
//       _orderdetail.insert(
//         0,
//         OrderDetail(
//           id: product.id,
//           title: product.title,
//           price: product.price,
//           quantity: product.quantity,
//           imageUrl: product.imageUrl,
//         ),
//       );
//     });
//     final _orderitem = OrderItem(
//       id: null,
//       amount: total,
//       tableNumber: tableNumber,
//       products: _orderdetail,
//       dateTime: DateTime.now(),
//     );
//     final newOrderItem = await _orderItemsService.addOrderItem(_orderitem);
//     if (newOrderItem != null) {
//       _orders.add(newOrderItem);
//     }
//     notifyListeners();
//   }
// }
