import 'package:flutter/material.dart ';
import 'cart_manager.dart';
import '../products/products_manager.dart';
import 'cart_item_card.dart';
import 'package:provider/provider.dart';
import '../orders/orders_manager.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart ';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int tableNumber = 0;
  String note = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    String tableNumber = '';
    String note = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận tạo hóa đơn '),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
              margin: const EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTitleField(),
                      buildNoteField(),
                    ],
                  ))),
          const SizedBox(height: 10),
          Expanded(
            child: buildCartDetails(cart),
          ),
          buildCartSummary(cart, context),
          buildOrderDetailCheckOut(cart, context),
        ],
      ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: tableNumber.toString(),
      decoration: const InputDecoration(labelText: 'Số bàn'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nhập số bàn';
        }
        if (int.tryParse(value) == null) {
          return 'Nhập số';
        }
        if (int.parse(value) <= 0) {
          return 'Nhập số bàn lớn hơn 0';
        }
        return null;
      },
      onSaved: (value) {
        tableNumber = int.parse(value!);
      },
    );
  }

  TextFormField buildNoteField() {
    return TextFormField(
      initialValue: note,
      decoration: const InputDecoration(labelText: 'Lưu ý'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          value = 'Không có';
        }
        return null;
      },
      onSaved: (value) {
        note = value!;
      },
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) => CartItemCard(
              productId: entry.key,
              cardItem: entry.value,
            ),
          )
          .toList(),
    );
  }

  Widget buildCartSummary(CartManager cart, BuildContext context) {
    final productsManager = new ProductsManager();
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Tổng tiền',
              style: TextStyle(fontSize: 17),
            ),
            const Spacer(),
            Chip(
              label: Text(
                productsManager.formatPrice(cart.totalAmount),
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryTextTheme.headline6?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderDetailCheckOut(CartManager cart, BuildContext context) {
    final productsManager = new ProductsManager();
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
              style: cart.totalAmount <= 0
                  ? ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.green.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.green.withOpacity(0.12);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    )
                  : ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.green.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.green.withOpacity(0.12);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
              onPressed: cart.totalAmount <= 0
                  ? null
                  : () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                      context.read<OrdersManager>().addOrder(
                            cart.products,
                            cart.totalAmount,
                            tableNumber,
                            note,
                          );
                      cart.clear();
                      tableNumber = 0;
                      Navigator.of(context).pushReplacementNamed('/orders');
                    },
              child: Text(
                'Tạo hóa đơn',
                style: TextStyle(fontSize: 17),
              )),
        ));
  }
}
