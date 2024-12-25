import 'package:flutter/material.dart';
import 'package:orders/api/services/cart_service.dart';

class CartIdsProvider extends ChangeNotifier {
  Set<int> ids = {};
  Future<void> getIds(token) async {
    final result = await CartService().getUserCartIds(token);
    if (result['ids'] != null) {
      ids = result['ids'].cast<int>();
    }
    notifyListeners();
  }

  void addId(id) {
    ids.add(id);
    notifyListeners();
  }

  void removeId(id) {
    ids.remove(id);
    notifyListeners();
  }

  void clearList() {
    ids = {};
  }
  
}
