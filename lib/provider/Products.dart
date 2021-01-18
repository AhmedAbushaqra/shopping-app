import 'package:flutter/material.dart';
import 'Product.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class Products with ChangeNotifier{
  List<Product> _items=[
   /* Product(
      id: '1',
      title: 'Red Shirt',
      description: 'Egyption Cotton Res Shirt For males',
      price: 150.99,
      picUrl: "https://i.ebayimg.com/images/g/hV0AAOSwpXBazsoZ/s-l300.jpg",
    ),
    Product(
      id: '2',
      title: 'Trousers',
      description: 'Jeans Trousers for females made in China',
      price: 80.80,
      picUrl: "https://image.made-in-china.com/43f34j00BdgQmwVJkYpW/Crowdordering-Low-MOQ-Light-Blue-Skinny-Ladies-Jeans.webp",
    ),
    Product(
      id: '3',
      title: 'Yellow Scarf',
      description: 'modern Yellow Scarf for both gender made in turkey',
      price: 49.99,
      picUrl: "https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg",
    ),
    Product(
      id: '4',
      title: 'pan',
      description: 'Using in Making Food',
      price: 49.99,
      picUrl: "https://cf1.s3.souqcdn.com/item/2019/03/31/50/33/90/76/item_XXL_50339076_b0f2b81b93d79.jpg",
    ),*/
  ];

  List<Product> get items{
    return [..._items];
  }

  List<Product> get FavoritItems{
    return _items.where((proudItem) => proudItem.isFavorite).toList();
  }

  Product FindById(String id){
    return _items.firstWhere((proud)=>proud.id==id);
  }

  final String AuthToken;
  final String UserId;
  Products(this.AuthToken,this.UserId,this._items);

  Future<void> FetchAndSetData([bool filterByUser=false])async{
    final filterString=filterByUser?'orderBy"CreatorId"&equalTo="$UserId"':'';
    var url = 'https://shop-app-38c66.firebaseio.com/Proudcts.json?auth=$AuthToken&$filterString';
    try{
     final response = await http.get(url,);
     final ExtractedData=json.decode(response.body)as Map<String,dynamic>;
     if(ExtractedData==null){
       return;
     }
     url ="https://shop-app-38c66.firebaseio.com/UserFavorites/$UserId.json?auth=$AuthToken";
     final FavoriteResponse=await http.get(url);
     final FavoriteData=json.decode(FavoriteResponse.body);
     final List<Product> loadedProduct =[];
     ExtractedData.forEach((prodId, prodData) {
       loadedProduct.add(Product(
         id: prodId,
         title: prodData['title'],
         description: prodData['description'],
         price: prodData['price'],
         picUrl: prodData['imageURL'],
         isFavorite: FavoriteData==null?false:FavoriteData[prodId]??false,
       ));
     });
     _items=loadedProduct;
     notifyListeners();
   } catch(Error){
     print(Error);
     throw Error;
   }
  }

  Future<void> addProduct(Product product){
    final url = "https://shop-app-38c66.firebaseio.com/Proudcts.json?auth=$AuthToken";
   return http.post(url,body: json.encode({
      'title':product.title,
      'description':product.description,
      'imageURL':product.picUrl,
      'price':product.price,
      'CreatorId':UserId,
    })).then((response) {
      final newProduct=Product(
        title: product.title,
        price: product.price,
        description: product.description,
        picUrl: product.picUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error){
      print(error);
      throw error;
   });
  }

  void UpdateProduct(String id , Product Newproduct)async{
    final ProdIndex=_items.indexWhere((prod) => prod.id==id);
    if(ProdIndex>=0){
      final url = "https://shop-app-38c66.firebaseio.com/Proudcts/$id.json?auth=$AuthToken";
      await http.patch(url,body: json.encode({
        'title':Newproduct.title,
        'description':Newproduct.description,
        'imageURL':Newproduct.picUrl,
        'price':Newproduct.price,
        'isfavorite':Newproduct.isFavorite,
      }));
      _items[ProdIndex]=Newproduct;
      notifyListeners();
    }else{
      print("....");
    }
  }
  void Deleteproduct(String id)async{
    final url = "https://shop-app-38c66.firebaseio.com/Proudcts/$id.json?auth=$AuthToken";
    final ExistingItemIndex=_items.indexWhere((prod) => prod.id==id);
    var ExistingItem=_items[ExistingItemIndex];
    _items.removeAt(ExistingItemIndex);
    notifyListeners();
    final Response = await http.delete(url);
    if(Response.statusCode>=400){
      _items.insert(ExistingItemIndex, ExistingItem);
      notifyListeners();
      throw Exception();
    }
      ExistingItem=null;
  }
}