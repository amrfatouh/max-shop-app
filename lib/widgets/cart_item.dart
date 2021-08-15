import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/cart_item.dart' as CartItemModel;

class CartItem extends StatelessWidget {
  final CartItemModel.CartItem item;
  const CartItem(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double totalPrice = item.quantity * item.price;
    return Dismissible(
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: EdgeInsets.all(3),
            child: FittedBox(
              child: Text('\$${totalPrice.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(item.title),
        subtitle: Text('Price of one piece: ${item.price}'),
        trailing: Text('x${item.quantity}'),
      ),
      key: ValueKey<String>(item.id),
      background: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        color: Colors.red[600],
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(item.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove that product?'),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
