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
  bool _isLoading = false;

  @override
  void initState() {
    setState(() => _isLoading = true);
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() => _isLoading = false));

    super.initState();
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(10),
        child: ProductsGrid(_showFavouritesOnly),
      ),
    );
  }
}
