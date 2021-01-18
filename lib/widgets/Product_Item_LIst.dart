import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Cart.dart';
import 'package:shop_app/provider/Product.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screens/ProductDetailScreen.dart';

class ProductItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product =Provider.of<Product>(context,listen: false);
    final cart =Provider.of<Cart>(context,listen: false);
    final auth=Provider.of<Auth>(context,listen: false);
    return Card(
    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
    child: Padding(
    padding: EdgeInsets.all(8),
    child: ListTile(
    leading: GestureDetector(
    onTap: (){
    Navigator.of(context).pushNamed(ProductDetailScreen.RouteName,arguments: product.id,);
    },
     child:Image.network(product.picUrl,fit: BoxFit.cover,)),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(width: 4,),
       Text(
        product.title,
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
        Consumer<Product>(
          builder: (ctx, product, child) => IconButton(
              icon: Icon(product.isFavorite?Icons.favorite:Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: (){
                product.ToggleFavoriteItem(auth.token,auth.userId);
              }
          ),
        ),
    ],
    ),
    //subtitle:
    trailing: IconButton(
        icon: Icon(Icons.shopping_cart),
        color: Theme.of(context).accentColor,
        onPressed: (){
          cart.addItem(context,product.id, product.price, product.title);
        }
    ),
    ),
    ),
    );
  }
}
