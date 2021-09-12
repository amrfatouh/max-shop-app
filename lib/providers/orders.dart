import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/orders.json';
    try {
      final response = await http.get(Uri.parse(url));
      final fetchedOrders = json.decode(response.body);
      List<OrderItem> loadedOrders = [];
      fetchedOrders.forEach((orderId, orderData) {
        List<CartItem> loadedCartItems = [];
        orderData['cartItems'].forEach((item) {
          loadedCartItems.add(CartItem.fromJson(item));
        });
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            cartItems: loadedCartItems,
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
          ),
        );
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addOrder(Cart cart) async {
    final url =
        'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/orders.json';
    final DateTime now = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': cart.totalPrice,
            'dateTime': now.toIso8601String(),
            'cartItems': cart.items
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'quantity': item.quantity,
                      'price': item.price,
                    })
                .toList(),
          }));
      final responseBody = json.decode(response.body);
      final orderId = responseBody['name'];
      _orders.add(
        OrderItem(
          id: orderId,
          amount: cart.totalPrice,
          cartItems: cart.items,
          dateTime: now,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    
  }
}
