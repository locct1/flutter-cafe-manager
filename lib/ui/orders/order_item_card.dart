import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_item.dart';
import '../products/products_manager.dart';
import '../cart/cart_screen.dart';
import 'order_detail_screen.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;
  const OrderItemCard(this.order, {super.key});
  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;
  final productsManager = new ProductsManager();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6),
      child: Column(
        children: <Widget>[
          buildOrderSummary(context),
          if (_expanded) buildOrderDetails()
        ],
      ),
    );
  }

  Widget buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      height: min(widget.order.productCount * 50.0 + 10, 100),
      child: ListView(
        children: widget.order.products
            .map(
              (prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    prod.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${prod.quantity}x \$${prod.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildOrderSummary(BuildContext context) {
    return GridTile(
            child: Column(
              children: [
                //CircleAvatar
                const SizedBox(
                  height: 10,
                ), //SizedBox
                Text(
                  'Bàn: ${widget.order.tableNumber}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ), //Text
                const SizedBox(
                  height: 10,
                ), //SizedBox
                Text(
                  'Tổng: ${productsManager.formatPrice(widget.order.amount)}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ), //Textstyle
                ), //Text
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Ngày: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.order.dateTime)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ), //Textstyle
                ), //Text
                const SizedBox(
                  height: 10,
                ),
                if (widget.order.status == '0')
                  Chip(
                    label: Text(
                      'Chưa thanh toán',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Color.fromARGB(255, 216, 16, 2),
                  ),
                if (widget.order.status == '1')
                  Chip(
                    label: Text(
                      'Đã thanh toán',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                    backgroundColor: Colors.green[900],
                  ),

                ///SizedBox
               ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(OrderDetailScreen.routeName,
                              arguments: widget.order.id)
                          .then((_) {
                        setState(() {});
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: const [Icon(Icons.touch_app)],
                      ),
                    ),
                  ),
                
              ],
            ),
         
        );
  }
}
