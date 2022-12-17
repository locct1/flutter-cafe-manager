import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'ui/screens.dart';

Future<void> main() async {
  // (1) Load the .env file
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, CategoriesManager>(
          create: (ctx) => CategoriesManager(),
          update: (ctx, authManager, categoriesManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            categoriesManager!.authToken = authManager.authToken;
            return categoriesManager;
          },
        ),
        ChangeNotifierProxyProvider<AuthManager, TotalExpensesManager>(
          create: (ctx) => TotalExpensesManager(),
          update: (ctx, authManager, totalexpensesManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            totalexpensesManager!.authToken = authManager.authToken;
            return totalexpensesManager;
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, OrdersManager>(
          create: (ctx) => OrdersManager(),
          update: (ctx, authManager, ordersManager) {
            // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
            // cho productManager
            ordersManager!.authToken = authManager.authToken;
            return ordersManager;
          },
        ),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        return MaterialApp(
          title: 'My Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.red,
              ).copyWith(
                secondary: Colors.black,
              ),
              scaffoldBackgroundColor: Color.fromARGB(255, 234, 200, 200)),
          home: authManager.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen();
                  }),
          routes: {
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            OrdersPaidScreen.routeName: (ctx) => const OrdersPaidScreen(),
            SummaryScreen.routeName: (ctx) => const SummaryScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            UserCategoriesScreen.routeName: (ctx) =>
                const UserCategoriesScreen(),
            UserTotalExpensesScreen.routeName: (ctx) =>
                const UserTotalExpensesScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == ProductDetailScreen.routeName) {
              final productId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (ctx) {
                  return ProductDetailScreen(
                    ctx.read<ProductsManager>().findById(productId),
                  );
                },
              );
            }
            if (settings.name == EditProductScreen.routeName) {
              final productId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditProductScreen(
                    productId != null
                        ? ctx.read<ProductsManager>().findById(productId)
                        : null,
                  );
                },
              );
            }
            if (settings.name == EditCategoryScreen.routeName) {
              final totalexpenseId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditCategoryScreen(
                    totalexpenseId != null
                        ? ctx.read<CategoriesManager>().findById(totalexpenseId)
                        : null,
                  );
                },
              );
            }
            if (settings.name == EditTotalExpenseScreen.routeName) {
              final categoryId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditTotalExpenseScreen(
                    categoryId != null
                        ? ctx.read<TotalExpensesManager>().findById(categoryId)
                        : null,
                  );
                },
              );
            }
            if (settings.name == OrderDetailScreen.routeName) {
              final orderItemId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return OrderDetailScreen(
                    orderItemId != null
                        ? ctx.read<OrdersManager>().findById(orderItemId)
                        : null,
                  );
                },
              );
            }
            if (settings.name == OrderAddProductScreen.routeName) {
              final orderItemId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return OrderAddProductScreen(
                    orderItemId != null
                        ? ctx.read<OrdersManager>().findById(orderItemId)
                        : null,
                  );
                },
              );
            }
            return null;
          },
        );
      }),
    );
  }
}
