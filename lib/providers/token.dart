import 'package:flutter/material.dart';

class TokenProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  login(String token) {
    _token = token;
    notifyListeners();
  }

  logout() {
    _token = token;
    notifyListeners();
  }
}
