import 'package:flutter/foundation.dart';
import 'package:shop_app/provider/Cart.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
   @required this.id,
   @required this.amount,
   @required this.products,
   @required this.dateTime,
});
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders=[];

  List<OrderItem> get orders{
    return [..._orders];
  }

  String AuthToken;
  String UserId;
  Orders(this.AuthToken,this.UserId,this._orders);

  Future<void> FetchAndsetOrders()async{
    final url = "https://shop-app-38c66.firebaseio.com/Orders/$UserId.json?auth=$AuthToken";
    final response = await http.get(url,);
    final List<OrderItem> loadedOrders =[];
    final ExtractedData=json.decode(response.body)as Map<String,dynamic>;
    if(ExtractedData==null){
      return;
    }
    ExtractedData.forEach((orderId, OrderData) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            amount: OrderData['amount'],
            dateTime: DateTime.parse(OrderData['dateTime']),
            products: (OrderData['Products']as List<dynamic>).map((item)=>
                CartItem(
                  id: item['id'],
                  price: item["price"],
                  quantity: item['quantity'],
                  title: item['title']
                )).toList(),
        )
      );
    });
    _orders=loadedOrders;
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartitem,double total)async{
    final url = "https://shop-app-38c66.firebaseio.com/Orders/$UserId.json?auth=$AuthToken";
    final timeStamp=DateTime.now();
   try {
     final Respons = await http.post(url, body: json.encode({
       'amount': total,
       'Products': cartitem.map((e) => {
         'id':e.id,
         'title':e.title,
         'quantity':e.quantity,
         'price':e.price,
       }).toList(),
       'dateTime': timeStamp.toIso8601String(),
     }));
     _orders.insert(0,
         OrderItem(
             id: json.decode(Respons.body)['name'],
             amount: total,
             products: cartitem,
             dateTime: timeStamp));
     notifyListeners();
   }catch(error){

   }
  }
}