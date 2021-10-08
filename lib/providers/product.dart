import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id;
  String title;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavourite(String token, String userId) async {
    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.parse(
        'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token');
    final response =
        await http.put(url, body: json.encode(isFavourite));
    if (response.statusCode >= 400) {
      isFavourite = !isFavourite;
      notifyListeners();
    }
  }
}
