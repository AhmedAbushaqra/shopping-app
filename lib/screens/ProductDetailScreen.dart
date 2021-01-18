import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const RouteName="./productdetail";
  @override
  Widget build(BuildContext context) {
    final ProductId=ModalRoute.of(context).settings.arguments as String;
    final LoadedProduct=Provider.of<Products>(context,listen: false).FindById(ProductId);
    return Scaffold(
      appBar: AppBar(
        title: Text(LoadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(LoadedProduct.picUrl,fit: BoxFit.cover,),
            ),
            SizedBox(height: 10,),
            Text(
                '\$${LoadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                LoadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
