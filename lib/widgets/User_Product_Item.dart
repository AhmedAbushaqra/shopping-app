import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Products.dart';
import 'package:shop_app/screens/Edite_Product_Screen.dart';

class UserProductItem extends StatelessWidget {
  final String id ;
  final String title;
  final String ImageUrl;

  UserProductItem(this.title,this.ImageUrl,this.id);
  @override
  Widget build(BuildContext context) {
    final scafold =Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(ImageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit,color: Theme.of(context).primaryColor,),
                onPressed: (){
                  Navigator.pushNamed(context, EditeProductScreen.routeName,arguments: id);
                }
            ),
            IconButton(
                icon: Icon(Icons.delete,color: Theme.of(context).errorColor,),
                onPressed: ()async{
                  try {
                    await Provider.of<Products>(context).Deleteproduct(id);
                  }catch(error){
                    scafold.showSnackBar(SnackBar(content: Text("Deleting Failed",textAlign: TextAlign.center,)));
                  }
                  }
            ),
          ],
        ),
      ),
    );
  }
}
