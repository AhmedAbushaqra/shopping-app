import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Product.dart';
import 'package:shop_app/provider/Products.dart';

class EditeProductScreen extends StatefulWidget {
  static const routeName = "/Edit_Product";

  @override
  _EditeProductScreenState createState() => _EditeProductScreenState();
}

class _EditeProductScreenState extends State<EditeProductScreen> {
  final _PriceFocusNode = FocusNode();
  final _DescriptionFocusNode = FocusNode();
  final _ImageUrlController = TextEditingController();
  final _ImageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
  Product(id: null,
      title: "",
      price: 0,
      description: "",
      picUrl: "");
  var _isInIt = true;
  var _isLoading = false;
  var _InItValues = {
    'title': '',
    'price': '',
    'describtion': '',
    'imageURL': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInIt) {
      final ProductId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
      if (ProductId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).FindById(ProductId);
        _InItValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'describtion': _editedProduct.description,
          'imageURL': '',
        };
        _ImageUrlController.text = _editedProduct.picUrl;
      }
    }
    _isInIt = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _ImageUrlFocus.addListener(_updateImageurl);
    super.initState();
  }

  @override
  void dispose() {
    _ImageUrlFocus.removeListener(_updateImageurl);
    _PriceFocusNode.dispose();
    _DescriptionFocusNode.dispose();
    _ImageUrlController.dispose();
    super.dispose();
  }

  void _updateImageurl() {
    if (!_ImageUrlFocus.hasFocus) {
      if (!_ImageUrlController.text.startsWith("http") &&
          !_ImageUrlController.text.startsWith("https") ||
          !_ImageUrlController.text.endsWith(".jpg") &&
              !_ImageUrlController.text.endsWith(".png") &&
              !_ImageUrlController.text.endsWith(".jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  void _SaveForm() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .UpdateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      }catch(error){
          await showDialog(context: context,
          builder: (ctx) =>
              AlertDialog(title: Text("An Error Occured!"),
                content: Text("SomeThing went Wrong"),
               actions: <Widget>[
                 FlatButton(onPressed:() {Navigator.of(context).pop();}, child: Text("Okay"),)
               ],
              ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _SaveForm)
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _InItValues['title'],
                  decoration: InputDecoration(labelText: "title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_PriceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter title";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      picUrl: _editedProduct.picUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _InItValues['price'],
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _PriceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_DescriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      picUrl: _editedProduct.picUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _InItValues['describtion'],
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _DescriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      picUrl: _editedProduct.picUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _ImageUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                        child: Image.network(
                          _ImageUrlController.text,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                        InputDecoration(labelText: "Image URL"),
                        keyboardType: TextInputType.url,
                        controller: _ImageUrlController,
                        textInputAction: TextInputAction.done,
                        focusNode: _ImageUrlFocus,
                        onFieldSubmitted: (_) {
                          _SaveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            picUrl: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Image URL";
                          }
                          if (!value.startsWith("http") &&
                              !value.startsWith("https")) {
                            return "Enter Valid URL";
                          }
                          if (!value.endsWith(".jpg") &&
                              !value.endsWith(".png") &&
                              !value.endsWith(".jpeg")) {
                            return "Enter Right Extintion";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
