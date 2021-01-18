import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Cart.dart';
import 'package:shop_app/provider/Product.dart';
import 'package:shop_app/provider/Products.dart';
import 'package:shop_app/screens/Cart_Screen.dart';
import 'package:shop_app/widgets/ProductGrid.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}
class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  void initState() {
    setState(() {
      _isloading=true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context).FetchAndSetData().then((_) {
        setState(() {
          _isloading=false;
        });
      });
    });
    super.initState();
  }
  Future<void> _RefreshProduct()async{
    await Provider.of<Products>(context).FetchAndSetData();
  }
  var _isloading=false;
  var _ShowOnlyFavorites=false;
  var _gridorlist=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          PopupMenuButton(
          onSelected: (int selectedValue){
            setState(() {
              if (selectedValue ==0){
                  _ShowOnlyFavorites=true;
              }if(selectedValue==1){
                _ShowOnlyFavorites=false;
              }
              if(selectedValue==2){
                _gridorlist=true;
              }
              if(selectedValue==3){
                _gridorlist=false;
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_)=>[
            PopupMenuItem(
              child: Text("Favorits"),
              value: 0,
            ),
            PopupMenuItem(
                child: Text("ShowAll"),
                value: 1,
            ),
            PopupMenuItem(
              child: Text("Grid"),
              value: 2,
            ),
            PopupMenuItem(
              child: Text("List"),
              value: 3,
            ),
          ]
      ),
          Consumer<Cart>(
              builder: (c, Cart, child) =>
                  Badge(
                      child: IconButton(
                          icon: Icon(Icons.shopping_cart),
                          onPressed: (){
                            Navigator.of(context).pushNamed(CartScreen.routeName);
                          }
                      ), value: Cart.ItemCount.toString(),
                  ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
          onRefresh: _RefreshProduct,
          child: _isloading?Center(child: CircularProgressIndicator(),): Product_grid(_ShowOnlyFavorites,_gridorlist)),
    );
  }
}