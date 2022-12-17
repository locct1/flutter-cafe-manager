import 'package:flutter/material.dart';
import 'user_category_list_tile.dart';
import 'categories_manager.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';
import 'edit_category_screen.dart';

class UserCategoriesScreen extends StatelessWidget {
  static const routeName = '/user-categories';
  const UserCategoriesScreen({super.key});
  Future<void> _refreshCategories(BuildContext context) async {
    await context.read<CategoriesManager>().fetchCategories(true);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesManager = CategoriesManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách loại sản phẩm'),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshCategories(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshCategories(context),
            child: buildUserCategoryListView(categoriesManager),
          );
        },
      ),
    );
  }

  Widget buildUserCategoryListView(CategoriesManager categoriesManager) {
    return Consumer<CategoriesManager>(
      builder: (ctx, categoriesManager, child) {
        return ListView.builder(
          itemCount: categoriesManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserCategoryListTile(
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
          EditCategoryScreen.routeName,
        );
      },
    );
  }
}
