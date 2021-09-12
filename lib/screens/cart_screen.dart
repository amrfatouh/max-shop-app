import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart';
  const CartScreen({Key key}) : super(key: key);

  Future<void> addOrder(screenContext) async {
    try {
      final Cart cart = Provider.of<Cart>(screenContext, listen: false);
      await Provider.of<Orders>(screenContext, listen: false).addOrder(cart);
      cart.clear();
    } catch (error) {
      await showDialog(
        context: screenContext,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Text(error.toString()),
          actions: [
            TextButton(
              child: Text('ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
      Navigator.of(screenContext).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Total Amount: \$${cart.totalPrice.toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: cart.itemsCount <= 0
                      ? null
                      : () => addOrder(context),
                  child: Text('ORDER NOW'),
                )
              ],
            ),
          ),
          // ElevatedButton(
          //   child: Text('Orders'),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(OrdersScreen.routeName);
          //   },
          // ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(cart.items[i]),
              itemCount: cart.itemsCount,
            ),
          )
        ],
      ),
    );
  }
}
