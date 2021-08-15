import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final showFavouritesOnly;
  const ProductsGrid(
    this.showFavouritesOnly, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = showFavouritesOnly
        ? Provider.of<Products>(context).favouriteProducts
        : Provider.of<Products>(context).products;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
    );
  }
}
