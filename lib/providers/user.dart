import 'package:flutter/material.dart';
import 'package:orders/models/User.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get loading => _isLoading;

  void setUser(User? user) {
    _user = user;
    _isLoading = false;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }
}
