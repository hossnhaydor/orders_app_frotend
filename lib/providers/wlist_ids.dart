import 'package:flutter/material.dart';
import 'package:orders/api/services/wishlist_service.dart';

class WishListIdsProvider extends ChangeNotifier {
  Set<int> ids = {};
  void getIds(token) async {
    final result = await WishlistService().getUserWishlistIds(token);
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
}
