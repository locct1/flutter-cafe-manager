import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../orders/orders_paid_screen.dart';
import '../products/user_products_screen.dart';
import '../categories/user_categories_screen.dart';
import '../totalexpenses/user_totalexpenses_screen.dart';
import '../products/products_overview_screen.dart';
import '../summary/summary_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Trang chính'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.shop),
          //   title: const Text('Shop'),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed('/');
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Hóa đơn chờ'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Hóa đơn đã thanh toán'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersPaidScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Quản lý sản phẩm'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Quản lý loại sản phẩm'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserCategoriesScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Quản lý tổng chi phí'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserTotalExpensesScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Tổng kết'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SummaryScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Đăng xuất'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
