import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Products.dart';
import 'package:shop_app/widgets/Product_Item.dart';
import 'package:shop_app/widgets/Product_Item_LIst.dart';

class Product_grid extends StatelessWidget {
  final bool Showfav;
  final bool isgrid;
  Product_grid(this.Showfav,this.isgrid);

 @override
  Widget build(BuildContext context) {
   final ProductsData=Provider.of<Products>(context);
   final Product=Showfav? ProductsData.FavoritItems:ProductsData.items;
    return isgrid?GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: Product.length,
      itemBuilder: (ctx,i)=>ChangeNotifierProvider.value(
        value:Product[i],
        child: ProductItem(
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    )
    :ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount:  Product.length,
      itemBuilder: (ctx,i)=>ChangeNotifierProvider.value(
        value:Product[i],
        child: ProductItemList(),
      ),
    );
  }
}
