import 'package:flutter/cupertino.dart';
import './product.dart';

class Products with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      title: 'Toy Tracktor',
      price: 10.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Toy_Excavator.jpg/320px-Toy_Excavator.jpg',
    ),
    Product(
      id: '2',
      title: 'Toy Assault Vehicle',
      price: 20,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Sentinel_1_Amphibious_Assault_Vehicle_Toy.jpg/640px-Sentinel_1_Amphibious_Assault_Vehicle_Toy.jpg',
    ),
    Product(
      id: '3',
      title: 'Yellow Toy Car',
      price: 4.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Yellow_toy_car.jpg/640px-Yellow_toy_car.jpg',
    ),
    Product(
      id: '4',
      title: 'Toy Robot',
      price: 25.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Ha_Ha_Toys%2C_Planet_Robot%2C_Blue%2C_Main_Street_Toys_Exclusive%2C_Front.jpg/640px-Ha_Ha_Toys%2C_Planet_Robot%2C_Blue%2C_Main_Street_Toys_Exclusive%2C_Front.jpg',
    ),
  ];

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

  Product findProductById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    if (!_products.any((prod) => prod.id == product.id)) return;
    int index = _products.indexWhere((prod) => prod.id == product.id);
    _products[index] = product;
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
