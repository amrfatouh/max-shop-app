import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';

enum Filter { AllProducts, Favourites }

class ProductsOverviewScreen extends StatefulWidget {
  static String routeName = '/';
  const ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavouritesOnly = false;
  bool _fetchingProductsError = false;
  String _errorMessage = '';
  Future<void> future;

  @override
  void initState() {
    super.initState();
    future = Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .catchError((error) {
      setState(() {
        _fetchingProductsError = true;
        _errorMessage = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('All Products'),
                value: Filter.AllProducts,
              ),
              PopupMenuItem(
                child: Text('Favourites'),
                value: Filter.Favourites,
              )
            ],
            onSelected: (Filter filter) {
              if (filter == Filter.AllProducts)
                setState(() => _showFavouritesOnly = false);
              else
                setState(() => _showFavouritesOnly = true);
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                Consumer<Cart>(
                  builder: (ctx, cart, child) => Text(
                    cart.itemsCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            // using connection state instead of hasData property as this future resolves with a void so it has no data even if it resolves successfully
            if (snapshot.connectionState == ConnectionState.done) {
              if (_fetchingProductsError)
                return Center(child: Text(_errorMessage));
              return Padding(
                padding: EdgeInsets.all(10),
                child: ProductsGrid(_showFavouritesOnly),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
