import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Cart.dart';

class CartItemShape extends StatelessWidget {
  final String id;
  final String ProductId;
  final String title;
  final double price;
  final int quantity;

  CartItemShape(
      this.id,
      this.ProductId,
      this.title,
      this.price,
      this.quantity,
      );
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
      Provider.of<Cart>(context,listen: false).RemoveItem(ProductId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                  child: FittedBox(
                      child: Text('\$$price',style: TextStyle(fontSize: 18),)
                  ),
              ),
            ),
            title: Text(title),
            subtitle: Text('total: \$${(quantity*price).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
