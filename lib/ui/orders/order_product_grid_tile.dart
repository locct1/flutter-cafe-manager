import 'package:flutter/material.dart';
import '../../models/order_detail.dart';
import '../cart/cart_manager.dart';
import 'package:provider/provider.dart';
import 'orders_manager.dart';
import 'package:intl/intl.dart';
import '../products/products_manager.dart';
import '../../models/order_item.dart';
import '../../models/product.dart';
class OrderProductGridTile extends StatelessWidget {
  const OrderProductGridTile(this.order,this.product, {super.key});
  final OrderItem order;
  final Product product;
  @override
  Widget build(BuildContext context) {
    final productsManager = ProductsManager();
    final ordersManager = context.read<OrdersManager>();
    final quantity = ValueNotifier<int>(0);
    quantity.value = ordersManager.findQuantity(product,order);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: GridTile(
          child: GestureDetector(
            onTap: () {},
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      product.title,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      productsManager.formatPrice(product.price),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Color.fromARGB(255, 144, 15, 6).withOpacity(0.6)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 36, 29, 29),
                            padding: const EdgeInsets.all(2.0),
                            textStyle: const TextStyle(fontSize: 12),
                            minimumSize: const Size(40, 30),
                          ),
                          onPressed: () {
                            final ordersManager = context.read<OrdersManager>();
                             ordersManager.removeSingleItem(product.id!,order);
                            quantity.value =
                                ordersManager.findQuantity(product,order);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Sản phẩm giảm 1',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      // ordersManager.addItem(product);
                                    },
                                  ),
                                ),
                              );
                          },
                          child: const Icon(Icons.remove),
                        ),
                        ValueListenableBuilder<int>(
                            valueListenable: quantity,
                            builder: (context, _quantity, child) {
                              return Text(
                                _quantity.toString(),
                                textAlign: TextAlign.center,
                              );
                            }),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 36, 29, 29),
                            padding: const EdgeInsets.all(3.0),
                            textStyle: const TextStyle(fontSize: 12),
                            minimumSize: Size(40, 30),
                          ),
                          onPressed: () {
                            final ordersManager = context.read<OrdersManager>();
                            ordersManager.addItem(product,order);
                            quantity.value =
                                ordersManager.findQuantity(product,order);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Sản phẩm tăng 1',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      // ordersManager.removeSingleItem(product.id!);
                                    },
                                  ),
                                ),
                              );
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    SizedBox(height: 5)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      title: Container(
        child: Column(
          children: [
            Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            Text(
              '${product.price}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
