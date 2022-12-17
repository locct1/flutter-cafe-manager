import 'package:flutter/material.dart ';
import '../products/products_manager.dart';
import '../shared/dialog_utils.dart';

import 'package:provider/provider.dart';
import '../orders/orders_manager.dart';
import '../../models/order_item.dart';
import 'order_detail_item_card.dart';
import 'orders_screen.dart';
import 'order_add_product_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/order-detail';

  OrderDetailScreen(
    OrderItem? order, {
    super.key,
  }) {
    if (order == null) {
      return;
    } else {
      this.order = order;
      // CategorySelect = product.category;
    }
  }
  late final OrderItem order;
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int tableNumber = 0;
  String note = '';
  final _formKey = GlobalKey<FormState>();
  late OrderItem _editOrder;

  @override
  void initState() {
    _editOrder = widget.order;
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      final ordersManager = context.read<OrdersManager>();
      if (_editOrder.id != null) {
        await ordersManager.updateOrderForm(_editOrder);
        await ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: const Text(
                'Cập nhật form thành công',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
      }
    } catch (error) {
      await showErrorDialog(context, 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrdersManager>();

    String tableNumber = '';
    String note = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
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
                      if (widget.order.status == '0')
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                onPressed: _saveForm,
                                child: Text('Sửa thông tin form'),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      OrderAddProductScreen.routeName,
                                      arguments: widget.order.id);
                                },
                                child: Text('Thêm món'),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ))),
          const SizedBox(height: 10),
          Expanded(
            child: buildOrderDetails(order),
          ),
          buildOrderDetailSummary(order, context),
          if (widget.order.status == '0')
            buildOrderDetailCheckOut(order, context),
        ],
      ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: widget.order.tableNumber.toString(),
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
        _editOrder = _editOrder.copyWith(tableNumber: int.parse(value!));
      },
    );
  }

  TextFormField buildNoteField() {
    return TextFormField(
      initialValue: widget.order.note.toString(),
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
        _editOrder = _editOrder.copyWith(note: value);
      },
    );
  }

  Widget buildOrderDetails(OrdersManager order) {
    return ListView.builder(
      itemCount: widget.order.products.length,
      itemBuilder: (ctx, i) => OrderDetailItemCard(
          productId: widget.order.products[i].id,
          orderDetail: widget.order.products[i]),
    );
  }

  Widget buildOrderDetailSummary(OrdersManager order, BuildContext context) {
    final productsManager = new ProductsManager();
    final ordersManager = context.read<OrdersManager>();
    final total = ValueNotifier<double>(0);
    total.value = ordersManager.orderAmount(widget.order);

    return Consumer<OrdersManager>(builder: (ctx, ordersManager, child) {
      return Card(
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Tổng:',
                style: TextStyle(fontSize: 17),
              ),
              const Spacer(),
              Chip(
                label: Text(
                  productsManager.formatPrice(total.value),
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
    });
  }

  Widget buildOrderDetailCheckOut(OrdersManager order, BuildContext context) {
    final order;
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
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
              onPressed: () async {
                await context
                    .read<OrdersManager>()
                    .confirmCheckOut(widget.order);
                await Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
              child: Text(
                'Xác nhận thanh toán',
                style: TextStyle(fontSize: 17),
              )),
        ));
  }
}
