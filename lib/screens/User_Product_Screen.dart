import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Product.dart';
import 'package:shop_app/screens/Edite_Product_Screen.dart';
import 'package:shop_app/widgets/User_Product_Item.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../provider/Products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName='/user-product';
  Future<void> _RefreshProduct(BuildContext context)async{
    await Provider.of<Products>(context,listen: false).FetchAndSetData();
  }
  @override
  Widget build(BuildContext context) {
   // final ProductData=Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.of(context).pushNamed(EditeProductScreen.routeName);
              }
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        builder: (ctx,snapshot)=> snapshot.connectionState==ConnectionState.waiting
          ?Center(child: CircularProgressIndicator(),):
        RefreshIndicator(
          onRefresh: ()=>_RefreshProduct(context),
          child: Consumer<Products>(
            builder: (ctx,ProductData,_)=>
                Padding(
                  padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: ProductData.items.length,
                  itemBuilder: (_,i)=> Column(
                    children: <Widget>[
                      UserProductItem(ProductData.items[i].title,ProductData.items[i].picUrl,ProductData.items[i].id),
                      Divider(),
                    ],
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
