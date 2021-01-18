import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
});
}


class Cart with ChangeNotifier{
  Map<String,CartItem> _items={};

  Map<String,CartItem> get items{
    return {..._items};
  }

  double get totalPrice{
    var total=0.0;
    _items.forEach((key, CartItem) {
      total+=CartItem.price*CartItem.quantity;
    });
    return total;
  }

  int get ItemCount{
    int inCart=0;
    _items.forEach((key, CartItem) {
      inCart+=CartItem.quantity;
    });
    return inCart;
  }

  void addItem(BuildContext context,String productId,double price,String title){
    if(_items.containsKey(productId)){
      _items.update(
            productId,
                (existingCartItem) => CartItem(
                  id: existingCartItem.id,
                  title: existingCartItem.title,
                  price: existingCartItem.price,
                  quantity: existingCartItem.quantity+1,
                )
        );
    }else{
      _items.putIfAbsent(
          productId,
              () => CartItem(
                id: DateTime.now().toString(),
                price: price,
                title: title,
                quantity: 1,
              )
      );
    }
    notifyListeners();
  }
  void RemoveItem(String ProductId){
    _items.remove(ProductId);
    notifyListeners();
  }
  void RemoveSingleItem(String ProductId){
    if(!_items.containsKey(ProductId)){
      return;
    }
    if(_items[ProductId].quantity > 1){
      _items.update(
          ProductId,
              (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity-1,
          )
      );
    }else{
      _items.remove(ProductId);
    }
    notifyListeners();
  }
  void Clear(){
    _items={};
    notifyListeners();
  }
}