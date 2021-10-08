import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
// import 'package:shop_app/models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final String _token;
  final String _userId;

  Products(this._token, this._userId, Products previousProducts) {
    if (previousProducts != null) {
      _products = previousProducts._products ?? [];
    }
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favouriteProducts {
    List<Product> favouriteProducts = [];
    _products.forEach((prod) {
      if (prod.isFavourite) favouriteProducts.add(prod);
    });
    return favouriteProducts;
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? '&orderBy="userId"&equalTo="$_userId"' : '';
    Uri url = Uri.parse(
        'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/products.json?auth=$_token$filterString');
    try {
      http.Response response = await http.get(url);
      final products = json.decode(response.body) as Map<String, dynamic>;
        url = Uri.parse(
          'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/userFavourites/$_userId.json?auth=$_token');
      response = await http.get(url);
      final userFavourites = json.decode(response.body);
      List<Product> _loadedProducts = [];
      products.forEach((productId, product) {
        bool isFavourite;
        if (userFavourites == null || userFavourites[productId] == null) {
          isFavourite = false;
        } else {
          isFavourite = userFavourites[productId];
        }

        _loadedProducts.add(Product(
            id: productId,
            title: product['title'],
            price: product['price'] +
              0.0, // firebase may return int or double, so we add 0.0 to cast the int into double
            imageUrl: product['imageUrl'],
            isFavourite: isFavourite,
          ));
      });
      _products = _loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findProductById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/products.json?auth=$_token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'userId': _userId
        }),
      );
      final receivedProduct = json.decode(response.body);
      final String id = receivedProduct['name'];
      product.id = id;
    _products.add(product);
    notifyListeners();
    } catch (error) {
      print('***********************************************');
      print('***********************************************');
      print('***********************************************');
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    if (_products.any((prod) => prod.id == product.id)) {
      final url = Uri.parse(
          'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$_token');
      try {
        await http.patch(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      int index = _products.indexWhere((prod) => prod.id == product.id);
      _products[index] = product;
      notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> removeProduct(String id) async {
    final index = _products.indexWhere((prod) => prod.id == id);
    final url = Uri.parse(
        'https://flutter-shop-fd9a3-default-rtdb.firebaseio.com/products/$id.json?auth=$_token');
    try {
      // firebase throws an error if something went wrong during deletion process
      await http.delete(url);
      _products.removeAt(index);
      notifyListeners();
    } catch (error) {
      print('error at removeProduct in providers/products.dart file');
      print(error);
      throw error;
    }
  }
}
