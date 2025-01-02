import 'package:flutter/material.dart';
import 'package:orders/api/services/auth_service.dart';
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

  void increaseAmmount(double ammount) {
    _user!.ammount += ammount;
    notifyListeners();
  }

  void decrement(double ammount) {
    _user!.ammount -= ammount;
    notifyListeners();
  }

  Future<bool> getUserByToken(String token) async {
    try {
      AuthService auth = AuthService();
      final result = await auth.getUserByToken(token);
      if (result == null) {
        throw ();
      }
      _user = result;
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }
}
