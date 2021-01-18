import 'package:flutter/material.dart';
import 'package:shop_app/provider/Cart.dart';
import 'package:shop_app/provider/Orders.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screens/Cart_Screen.dart';
import 'package:shop_app/screens/Edite_Product_Screen.dart';
import 'package:shop_app/screens/Products_OverView_Screen.dart';
import 'package:shop_app/provider/Products.dart';
import 'package:shop_app/screens/ProductDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/User_Product_Screen.dart';
import 'package:shop_app/screens/orders_Screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ChangeNotifierProxyProvider<Auth,Products>(
        builder: (ctx,auth,previousProducts)=>Products(auth.token,auth.userId,previousProducts==null?[]:previousProducts.items),
       ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth,Orders>(
          builder:(ctx,auth,previousOrders)=> Orders(auth.token,auth.userId,previousOrders==null?[]:previousOrders.orders),
        ),
     ],
      child: Consumer<Auth>(builder: (ctx, auth, _) => MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: auth.isAuth?ProductsOverviewScreen():FutureBuilder(
          future:auth.tryAutoLogin(),
          builder: (ctx,authResultSnapshot)=>
             authResultSnapshot==ConnectionState.waiting?SplashScreen():AuthScreen()
        ),
        routes: {
          ProductDetailScreen.RouteName:(ctx)=>ProductDetailScreen(),
          CartScreen.routeName:(ctx)=>CartScreen(),
          OrderScreen.routeName:(ctx)=>OrderScreen(),
          UserProductScreen.routeName:(ctx)=>UserProductScreen(),
          EditeProductScreen.routeName:(ctx)=>EditeProductScreen(),
        },
      ),)
    );
  }
}