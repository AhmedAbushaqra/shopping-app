import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Cart.dart';
import 'package:shop_app/provider/Product.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screens/ProductDetailScreen.dart';

class ProductItem extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
   final product =Provider.of<Product>(context,listen: false);
   final cart =Provider.of<Cart>(context,listen: false);
   final auth =Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(ProductDetailScreen.RouteName,arguments: product.id,);
            },
            child: Image.network(product.picUrl,fit: BoxFit.cover,)),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavorite?Icons.favorite:Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: (){
                  product.ToggleFavoriteItem(auth.token,auth.userId);
                }
                ),
          ),
          title: Text(
            product.title,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: (){
                cart.addItem(context,product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                    SnackBar(
                        content:Text("Item Added to Cart"),
                        duration: Duration(seconds: 1),
                        action: SnackBarAction(label: "Undo", 
                            onPressed: (){
                               cart.RemoveSingleItem(product.id);
                            }),
                    )
                );
              }
              ),
        ),
      ),
    );
  }
}
