import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  void toggleFavourite() async {
    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.parse(
        'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/products/$id.json');
    final response =
        await http.patch(url, body: json.encode({'isFavourite': isFavourite}));
    if (response.statusCode >= 400) {
      isFavourite = !isFavourite;
      notifyListeners();
    }
  }
}
