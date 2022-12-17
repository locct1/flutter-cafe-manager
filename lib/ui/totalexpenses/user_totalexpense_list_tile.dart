import 'package:flutter/material.dart';
import '../../models/total_expense.dart';
import 'totalexpenses_manager.dart';
import 'package:provider/provider.dart';
import 'edit_totalexpense_screen.dart';
import '../products/products_manager.dart';
import 'package:intl/intl.dart';

class UserTotalExpenseListTile extends StatelessWidget {
  final TotalExpense totalexpense;

  const UserTotalExpenseListTile(
    this.totalexpense, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productsManager = new ProductsManager();

    return ListTile(
      title: Container(
         alignment: Alignment.bottomLeft,
        child: Column(
          children: [
            Row(
              children: [
                Text(totalexpense.description,style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),),
              ],
            ),
              Row(
              children: [
               Text(productsManager.formatPrice(totalexpense.price),style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),),
              ],
            ),
              Row(
              children: [
                Text(
                  'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(totalexpense.dateTime)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ), //Textstyle
                ), 
              ],
            ),
           
            
          ],
        ),
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
        context
            .read<TotalExpensesManager>()
            .deleteTotalExpense(totalexpense.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'TotalExpense deleted',
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
          EditTotalExpenseScreen.routeName,
          arguments: totalexpense.id,
        );
      },
      color: Theme.of(context).primaryColor,
    );
  }
}
