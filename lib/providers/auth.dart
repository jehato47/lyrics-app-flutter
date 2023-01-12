import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/http_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;
  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBHPwangZj_ZrB3l5_ZXsTjOrBoV0XRpFM";

    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
    final extractedData = json.decode(response.body);
    if (extractedData["error"] != null) {
      throw HttpException(extractedData["error"]["message"]);
    }

    // print(extractedData);
    _userId = extractedData["localId"];
    _token = extractedData["idToken"];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(extractedData["expiresIn"]),
      ),
    );

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "token": _token,
      "userId": _userId,
      "expiryDate": _expiryDate!.toIso8601String(),
    });
    prefs.setString("userData", userData);
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate =
        DateTime.parse((extractedUserData['expiryDate'] as String));

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = (extractedUserData['token'] as String);
    _userId = (extractedUserData['userId'] as String);
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
