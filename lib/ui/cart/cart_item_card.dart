import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../shared/dialog_utils.dart';
import 'cart_manager.dart';
import '../products/products_manager.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final String productId;
  final CartItem cardItem;
  const CartItemCard({
    required this.productId,
    required this.cardItem,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cardItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showConfirmDialog(
          context,
          'Do you want to remove the item from the cart ?',
        );
      },
      onDismissed: (direction) {
        context.read<CartManager>().removeItem(productId);
      },
      child: buildItemCard(context),
    );
  }

  Widget buildItemCard(BuildContext context) {
    final productsManager = new ProductsManager();

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all((10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(
                  cardItem.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardItem.title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: productsManager.formatPrice(cardItem.price),
                  style: TextStyle(fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: ' x ${cardItem.quantity}',
                    ),
                  ],
                ),
              ),

              Chip(
                label: Text(
                  productsManager
                      .formatPrice(cardItem.price * cardItem.quantity),
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6?.color,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}
