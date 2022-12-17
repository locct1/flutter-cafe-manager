import 'package:flutter/material.dart';
import 'orders_manager.dart';
import 'order_item_card.dart';
import '../shared/app_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../models/order_item.dart';

class OrdersPaidScreen extends StatefulWidget {
  static const routeName = '/orders-paid';
  const OrdersPaidScreen({super.key});

  @override
  State<OrdersPaidScreen> createState() => _OrdersPaidScreenState();
}

class _OrdersPaidScreenState extends State<OrdersPaidScreen> {
  late Future<void> _fetchOrderItems;
  @override
  void initState() {
    super.initState();
    _fetchOrderItems = context.read<OrdersManager>().fetchOrderItems();
  }

  @override
  Widget build(BuildContext context) {
    final ordersManager = new OrdersManager();
    final orders = context.select<OrdersManager, List<OrderItem>>(
        (ordersManager) => ordersManager.Paid());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn đã thanh toán'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _fetchOrderItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<OrdersManager>(
                builder: (ctx, ordersManager, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(5.0),
                    itemCount: orders.length,
                    itemBuilder: (ctx, i) => OrderItemCard(orders[i]),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1 / 1.2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
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
