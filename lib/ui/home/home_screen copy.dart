import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';
import '../products/products_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> entries = <String>['Đồ ăn', 'Đồ uống', ''];
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
        ),
        drawer: const AppDrawer(),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              buildCategories(),
              Container()
            ],
          ),
        ));
  }

  Widget buildCategories() {
    return Row(children: [
      TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered))
                  return Colors.red.withOpacity(0.04);
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed))
                  return Colors.red.withOpacity(0.12);
                return null; // Defer to the widget's default.
              },
            ),
          ),
          onPressed: () {},
          child: Text('Tất cả', style: TextStyle(fontSize: 20))),
      TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered))
                  return Colors.blue.withOpacity(0.04);
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed))
                  return Colors.blue.withOpacity(0.12);
                return null; // Defer to the widget's default.
              },
            ),
          ),
          onPressed: () {},
          child: Text('Đồ uống', style: TextStyle(fontSize: 20))),
      TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
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
          onPressed: () {},
          child: Text('Đồ ăn', style: TextStyle(fontSize: 20))),
      TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered))
                  return Colors.black.withOpacity(0.04);
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed))
                  return Colors.black.withOpacity(0.12);
                return null; // Defer to the widget's default.
              },
            ),
          ),
          onPressed: () {},
          child: Text('Khác', style: TextStyle(fontSize: 20))),
    ]);
  }
}

Widget buildCategories() {
  return Container(
    width: 150.0,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Column(children: [
      Container(
        margin: const EdgeInsets.only(
          top: 10.0,
        ),
        height: 130.0,
        width: 130.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://images.unsplash.com/photo-1521503862198-2ae9a997bbc9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=60'),
          ),
        ),
      ),
    ]),
  );
}


