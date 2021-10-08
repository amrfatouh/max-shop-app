import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/create_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatefulWidget {
  static String routeName = '/user-products';
  const UserProductsScreen({Key key}) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CreateProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(true);
        },
        child: ListView.builder(
          itemCount: productsData.products.length,
          itemBuilder: (ctx, i) => UserProductItem(productsData.products[i]),
        ),
      ),
    );
  }
}
