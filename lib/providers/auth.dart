import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_shop/models/myHttpException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> authentication(
      String userChoice, String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$userChoice?key=AIzaSyDmWBJhgHJjT-SelZV3t8YSsJP7vxxTOKw');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        // print(responseData['error']['message']);
        throw MyHttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      print('===========================set');
      // print(json.encode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    await authentication('signUp', email, password);
  }

  Future<void> login(String email, String password) async {
    await authentication('signInWithPassword', email, password);
  }
}
