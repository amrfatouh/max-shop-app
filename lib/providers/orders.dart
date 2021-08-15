import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return [..._orders];
  }

  void addOrder(Cart cart) {
    _orders.add(
      OrderItem(
        id: 'Order_${DateTime.now().toIso8601String()}',
        amount: cart.totalPrice,
        cartItems: cart.items,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
