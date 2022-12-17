import 'package:flutter/material.dart';
import 'user_totalexpense_list_tile.dart';
import 'totalexpenses_manager.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';
import 'edit_totalexpense_screen.dart';

class UserTotalExpensesScreen extends StatelessWidget {
  static const routeName = '/user-totalexpenses';
  const UserTotalExpensesScreen({super.key});
  Future<void> _refreshTotalExpenses(BuildContext context) async {
    await context.read<TotalExpensesManager>().fetchTotalExpenses(true);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesManager = TotalExpensesManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách chi phí'),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshTotalExpenses(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshTotalExpenses(context),
            child: buildUserTotalExpenseListView(categoriesManager),
          );
        },
      ),
    );
  }

  Widget buildUserTotalExpenseListView(TotalExpensesManager categoriesManager) {
    return Consumer<TotalExpensesManager>(
      builder: (ctx, categoriesManager, child) {
        return ListView.builder(
          itemCount: categoriesManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserTotalExpenseListTile(
                categoriesManager.items[i],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditTotalExpenseScreen.routeName,
        );
      },
    );
  }
}
