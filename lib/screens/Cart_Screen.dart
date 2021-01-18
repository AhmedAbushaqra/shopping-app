import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Cart.dart';
import 'package:shop_app/provider/Orders.dart';
import 'package:shop_app/widgets/CartItem.dart';

class CartScreen extends StatelessWidget {
  static const routeName='/cart';
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child:Padding(
                padding:EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total',style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(
                    label: Text(
                        "\$${cart.totalPrice.toStringAsFixed(2)}",style: TextStyle(fontSize: 18,color: Colors.white),),
                    backgroundColor: Theme.of(context).primaryColor,),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: OrderButton(cart: cart),
                  ),
                ],
              ),
            ) ,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder:(context, i) => CartItemShape(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].title,
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                  ),
              ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: _isloading?CircularProgressIndicator():Text('Order Now',style: TextStyle(color: Theme.of(context).primaryColor),),
        onPressed: (widget.cart.totalPrice<=0||_isloading)?null:()async{
        setState(() {
          _isloading=true;
        });
        await Provider.of<Orders>(context).addOrders(widget.cart.items.values.toList(), widget.cart.totalPrice);
        _isloading=false;
        widget.cart.Clear();
        }
    );
  }
}
