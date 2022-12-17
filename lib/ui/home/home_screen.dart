import 'package:flutter/material.dart';
import '../products/products_grid.dart';
import '../shared/app_drawer.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_manager.dart';
import '../products/products_manager.dart';
import '../products/top_right_badge.dart';
import 'package:provider/provider.dart';
import '../products/products_overview_screen.dart';
import '../categories/categories_manager.dart';
import '../../models/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  final _showCategory = ValueNotifier<String>('');
  late Future<void> _fetchProducts;
  late Future<void> _fetchCategories;

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
    _fetchCategories = context.read<CategoriesManager>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          buildProductFilterMenu(),
          buildShoppingCartIcon(),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 25),
            ),
            onPressed: () {
              _showCategory.value = '';
            },
            child: Container(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: ChoiceChip(
                  selectedColor: Colors.black,
                  backgroundColor: Colors.purple,
                  selected: _showCategory.value == '',
                  label: Text(
                    'MENU CỦA QUÁN',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onSelected: (selected) {
                    setState(() => _showCategory.value = '');
                  },
                )),
          ),
          buildCategories(context),
          Expanded(
            child: FutureBuilder(
                future: _fetchProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ValueListenableBuilder<String>(
                        valueListenable: _showCategory,
                        builder: (context, _showCategory, child) {
                          return ProductsGrid(_showCategory);
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
    );
  }

  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(ctx).pushNamed(CartScreen.routeName).then((_) {
                setState(() {});
              });
            },
          ),
        );
      },
    );
  }

  Widget buildProductFilterMenu() {
    final cart = context.read<CartManager>();
    return IconButton(
      icon: const Icon(
        Icons.delete,
      ),
      onPressed: () {
        cart.clear();
         Navigator.of(context)
                  .pushReplacementNamed(HomeScreen.routeName);
      },
    );
  }

  Widget buildCategories(BuildContext context) {
    final categoriesManager = new CategoriesManager();
    // Đọc ra danh sách các product sẽ được hiển thị từ ProductsManager
    final categories = context.select<CategoriesManager, List<CategoryModel>>(
        (categoriesManager) => categoriesManager.items);
    return Container(
      height: 50,
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: ChoiceChip(
                  selectedColor: Colors.black,
                  backgroundColor: Colors.purple,
                  selected: _showCategory.value == categories[index].id,
                  label: Text(
                    '${categories[index].title}',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  onSelected: (selected) {
                    setState(
                        () => _showCategory.value = categories[index].id ?? '');
                  },
                ));
          }),
    );
    ;
  }
}
