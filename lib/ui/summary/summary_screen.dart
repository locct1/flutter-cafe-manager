import 'package:flutter/material.dart';
import '../orders/orders_manager.dart';
import '../totalexpenses/totalexpenses_manager.dart';
import '../shared/app_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../models/order_item.dart';
import '../../models/total_expense.dart';
import '../products/products_manager.dart';

class SummaryScreen extends StatefulWidget {
  static const routeName = '/summary';
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Future<void> _fetchOrderItems;
  late Future<void> _fetchTotalExpenses;
  @override
  void initState() {
    super.initState();
    _fetchOrderItems = context.read<OrdersManager>().fetchOrderItems();
    _fetchTotalExpenses =
        context.read<TotalExpensesManager>().fetchTotalExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final ordersManager = new OrdersManager();
    final totalExpensesManager = new TotalExpensesManager();
    final productManager = new ProductsManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng kết'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _fetchOrderItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer2<OrdersManager, TotalExpensesManager>(
                builder: (ctx, ordersManager, totalExpensesManager, child) {
                  return Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: SizedBox(
                      height: 200,
                      child: Container(
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Center(
                            child: Column(
                          children: [
                            Text(
                                'Tổng doanh thu: ' +
                                    productManager
                                        .formatPrice(ordersManager.totalAmount),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                )),
                            Text(
                                'Tổng chi phí: ' +
                                    productManager.formatPrice(
                                        totalExpensesManager.totalAmount),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                )),
                            Text(
                                'Lợi nhuận: ' +
                                    productManager.formatPrice(
                                        ordersManager.totalAmount -
                                            totalExpensesManager.totalAmount),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.red,
                                )),
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
