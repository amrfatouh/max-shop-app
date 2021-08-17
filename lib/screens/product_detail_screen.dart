import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = '/product-detail';

  const ProductDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    Product product = Provider.of<Products>(context, listen: false)
        .findProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 15),
          Text(
            product.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            child: Text(
              'Price: \$${product.price}',
              style: TextStyle(color: Colors.blue),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Colors.blue)),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Add to cart'),
            onPressed: () {
              Provider.of<Cart>(context, listen: false).addCartItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product added to cart!'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          )
        ],
      )),
    );
  }
}
