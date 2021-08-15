import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart_item.dart';

class OrderItem {
  String id;
  double amount;
  List<CartItem> cartItems;
  DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.cartItems,
    @required this.dateTime,
  });
}
