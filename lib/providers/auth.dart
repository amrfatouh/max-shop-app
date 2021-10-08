import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;
  Timer _timer;

  bool get isSignedIn {
    return token != null && expiryDate.isAfter(DateTime.now());
  }

  Future<void> signup(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAAfeGQW9ji0RZtJhk-3qbKvVbZKERY5qQ';
    try {
      final request = await http.post(Uri.parse(url), body: {
        'email': email,
        'password': password,
        'returnSecureToken': 'true',
      });
      final userData = json.decode(request.body);
      if (request.statusCode == 400)
        throw HttpException(userData['error']['message']);
      token = userData['idToken'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(userData['expiresIn'])));
      userId = userData['localId'];
      notifyListeners();
      autoLogout();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'userData',
        json.encode(
          {
            'token': token,
            'userId': userId,
            'expiryDate': expiryDate.toString(),
          },
        ),
      );
    } catch (error) {
      print('my firebase error ocurred: $error');
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    final uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAAfeGQW9ji0RZtJhk-3qbKvVbZKERY5qQ';
    try {
      final request = await http.post(Uri.parse(uri), body: {
        'email': email,
        'password': password,
        'returnSecureToken': 'true',
      });
      final userData = json.decode(request.body);
      if (request.statusCode == 400)
        throw HttpException(userData['error']['message']);
      token = userData['idToken'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(userData['expiresIn'])));
      userId = userData['localId'];
      notifyListeners();
      autoLogout();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'userData',
        json.encode(
          {
            'token': token,
            'userId': userId,
            'expiryDate': expiryDate.toString(),
          },
        ),
      );
    } catch (error) {
      print('my firebase error ocurred: $error');
      throw error;
    }
  }

  Future<void> logout() async {
    token = userId = expiryDate = null;
    notifyListeners();
    _timer.cancel();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  void autoLogout() {
    _timer = Timer(Duration(seconds: 3), logout);
  }

  Future<bool> tryAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    String stringUserData = prefs.getString('userData');
    Map<String, dynamic> userData = json.decode(stringUserData);
    DateTime storedExpiryDate = DateTime.parse(userData['expiryDate']);
    if (storedExpiryDate.isBefore(DateTime.now())) return false;

    expiryDate = storedExpiryDate;
    userId = userData['userId'];
    token = userData['token'];
    notifyListeners();
    autoLogout();
    return true;
  }
}
