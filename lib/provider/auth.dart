import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _Token;
  DateTime _ExpireDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth{
    return token !=null;
  }
  String get token{
    if(_ExpireDate!=null && _ExpireDate.isAfter(DateTime.now())&& _Token!=null){
      return _Token;
    }
    return null;
  }
  String get userId{
    return _userId;
  }
  Future<void> _Authenticate(String Email,String Password,String urlsegmant)async{
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlsegmant?key=AIzaSyDpmUHOgYP7shbLxHFPuupCBGbU9F28fSs';
    try {
      final response = await http.post(
          url,
          body: json.encode(
            {
              'email': Email,
              'password': Password,
              'returnSecureToken': true,
            },
          ));
      final responseData = json.decode(response.body);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }
      _Token=responseData['idToken'];
      _userId=responseData['localId'];
      _ExpireDate=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogOut();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final userData=json.encode({
        'token':_Token,
        'userId':_userId,
        'expiryDate':_ExpireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    }catch(error){
     throw error;
    }
  }

  Future<void> SignUp(String Email, String Password) async {
    return _Authenticate(Email, Password, 'signUp');
  }
  Future<void> LogIn(String Email,String Password)async{
    return _Authenticate(Email, Password, 'signInWithPassword');
  }
  Future<bool> tryAutoLogin()async{
    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData=json.decode(prefs.getString('userData'))as Map<String,Object>;
    final expiryDate=DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _Token=extractedUserData['token'];
    _userId=extractedUserData['userId'];
    _ExpireDate=expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }
  Future<void> LogOut()async{
    _Token=null;
    _userId=null;
    _ExpireDate=null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final prefs=await SharedPreferences.getInstance();
    prefs.clear();
}
void _autoLogOut(){
if(_authTimer!=null){
  _authTimer.cancel();
}
final TimeToExpiry=_ExpireDate.difference(DateTime.now()).inSeconds;
_authTimer=Timer(Duration(seconds: TimeToExpiry), LogOut);
}
}
