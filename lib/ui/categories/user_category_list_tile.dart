import 'package:flutter/material.dart';
import '../../models/category.dart';
import 'categories_manager.dart';
import 'package:provider/provider.dart';
import 'edit_category_screen.dart';

class UserCategoryListTile extends StatelessWidget {
  final CategoryModel category;

  const UserCategoryListTile(
    this.category, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.title),
      leading: CircleAvatar(
      
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            buildEditButton(context),
            buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        context.read<CategoriesManager>().deleteCategory(category.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Category deleted',
                textAlign: TextAlign.center,
              ),
            ),
          );
      },
      color: Theme.of(context).errorColor,
    );
  }

  Widget buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditCategoryScreen.routeName,
          arguments: category.id,
        );
      },
      color: Theme.of(context).primaryColor,
    );
  }
}
