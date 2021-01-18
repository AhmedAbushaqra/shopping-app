import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final String picUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.picUrl,
    @required this.price,
    this.isFavorite=false,
});
  Future<void> ToggleFavoriteItem(String AuthToken,String UserId)async{
   final oldStatus=isFavorite;
    isFavorite =!isFavorite;
     notifyListeners();
   final url = "https://shop-app-38c66.firebaseio.com/UserFavorites/$UserId/$id.json?auth=$AuthToken";
   try {
     final Response=await http.put(url, body: json.encode(
       isFavorite,
     ),
     );
     if(Response.statusCode>=400){
       isFavorite=oldStatus;
       notifyListeners();
     }
   }catch(error){
     isFavorite = oldStatus;
     notifyListeners();
   }
  }
}