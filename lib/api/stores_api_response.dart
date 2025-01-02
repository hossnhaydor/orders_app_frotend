import 'package:orders/models/Store.dart';

class StoresApiResponse<T> {
  String? error;
  List<Store>? stores;
  StoresApiResponse({required this.error, required this.stores});

  bool get hasError => error != null;
  bool get isEmpty => stores == null || !stores!.isNotEmpty;
  String? get getError => error;
  List<Store>? get getStores => stores;
}
