import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/order_item.dart' as OrderModel;

class OrderItem extends StatefulWidget {
  final OrderModel.OrderItem order;
  const OrderItem(this.order, {Key key}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          ),
          if (isExpanded)
            Container(
              child: Padding(
                padding: EdgeInsets.all(6),
                child: ListTile(
                  title: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    height: 80,
                    child: ListView.builder(
                      itemBuilder: (ctx, i) {
                        final CartItem cartItem = widget.order.cartItems[i];
                        return Text(
                            '${cartItem.title} - ${cartItem.quantity}x - \$${cartItem.price}');
                      },
                      itemCount: widget.order.cartItems.length,
                    ),
                  ),
                ),
              ),
            ),
          Divider(),
        ],
      ),
    );
  }
}
