import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Orders.dart';
import 'package:shop_app/widgets/OrdersItem.dart';
import 'package:shop_app/widgets/drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName='/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context).FetchAndsetOrders();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItemShape(orderData.orders[i]),
      ),
    );
  }
}
