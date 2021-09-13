import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;

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
    } catch (error) {
      print('my firebase error ocurred: $error');
      throw error;
    }
  }
}
