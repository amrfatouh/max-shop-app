import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_item.dart' as OrderModel;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = '/orders';
  const OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  void fetchAndSetOrders() {
    // using catchError instead of try catch statement as the latter didn't catch FormatException and SocketExcpetion types
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .catchError((error) {
      print(error.runtimeType);
      showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text(error.toString()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('ok'),
                      )
                    ],
                  ),
              barrierDismissible: false)
          .then((_) => Navigator.of(context)
              .pushReplacementNamed(ProductsOverviewScreen.routeName));
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    final List<OrderModel.OrderItem> orders =
        Provider.of<Orders>(context).items;
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (ctx, i) => OrderItem(orders[i]),
          itemCount: orders.length,
        ));
  }
}
