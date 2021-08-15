import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  double price;
  String imageUrl;
  bool isFavourite = false;

  Product({
    this.id,
    this.title,
    this.price,
    this.imageUrl,
  });

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
