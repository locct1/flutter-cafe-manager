import 'package:flutter/material.dart';
import 'orders_manager.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';
import '../../models/order_item.dart';
import '../../models/order_detail.dart';
import 'order_product_grid_tile.dart';
import '../products/products_manager.dart';

class OrderProductsGrid extends StatelessWidget {
  final String _showCategory;
  final OrderItem order;
  const OrderProductsGrid(this._showCategory, this.order, {super.key});
  @override
  Widget build(BuildContext context) {
    final products = context.select<ProductsManager, List<Product>>(
        (productsManager) => productsManager.productByCategory(_showCategory));
    // Đọc ra danh sách các product sẽ được hiển thị từ ProductsManager
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => OrderProductGridTile(order, products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8 / 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
