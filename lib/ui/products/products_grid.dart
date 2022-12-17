import 'package:flutter/material.dart';
import 'product_grid_tile.dart';
import 'products_manager.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final String _showCategory;
  const ProductsGrid(this._showCategory, {super.key});
  
  @override
  Widget build(BuildContext context) {
    final productsManager = new ProductsManager();
    // Đọc ra danh sách các product sẽ được hiển thị từ ProductsManager
    final products = context.select<ProductsManager, List<Product>>(
        (productsManager) => productsManager.productByCategory(_showCategory));
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8 / 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
