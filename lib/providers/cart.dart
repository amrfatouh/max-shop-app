import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  List<CartItem> get items {
    return _items.values.toList();
  }

  void addCartItem(Product product) {
    if (!_items.containsKey(product.id)) {
      CartItem item = CartItem(
          id: 'CartItem_${DateTime.now().toIso8601String()}',
          title: product.title,
          quantity: 1,
          price: product.price);
      _items.putIfAbsent(product.id, () => item);
    } else {
      _items.update(product.id, (currentItem) {
        currentItem.quantity++;
        return currentItem;
      });
    }
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  void removeItem(String id) {
    _items.removeWhere((productId, item) => item.id == id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity == 1)
      _items.remove(productId);
    else
      _items[productId].quantity--;
    notifyListeners();
  }

  double get totalPrice {
    double sum = 0;
    _items.forEach((productId, item) {
      sum += item.quantity * item.price;
    });
    return sum;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
