import 'package:flutter/cupertino.dart';
import '../models/product.dart';

class ProductManager extends ChangeNotifier {
  List<ProductModel> productsInCartList = [];
  List<ProductCountModel> productsInCartCount = [];

  addToCart(ProductModel item) {
    int isOnceAdded =
        productsInCartCount.indexWhere((element) => element.id == item.id);
    if (isOnceAdded == -1) {
      ProductCountModel pCount = ProductCountModel(id: item.id, count: 1);

      productsInCartList.add(item);
      productsInCartCount.add(pCount);
    } else {
      productsInCartCount[isOnceAdded].count++;
    }

    notifyListeners();
  }

  substractFromCart(item) {
    int isOnceAdded =
        productsInCartCount.indexWhere((element) => element.id == item.id);
    if (isOnceAdded != -1) {
      if (productsInCartCount[isOnceAdded].count > 1) {
        productsInCartCount[isOnceAdded].count--;
      } else {
        productsInCartList.removeWhere((element) => element.id == item.id);
        productsInCartCount.removeWhere((element) => element.id == item.id);
      }
    } else {
      debugPrint("wrong calling to remove");
    }

    notifyListeners();
  }

  removeFromCart(item) {
    int isOnceAdded =
        productsInCartCount.indexWhere((element) => element.id == item.id);
    if (isOnceAdded != -1) {
      productsInCartList.removeWhere((element) => element.id == item.id);
      productsInCartCount.removeWhere((element) => element.id == item.id);
    } else {
      debugPrint("wrong calling to remove");
    }

    notifyListeners();
  }

  int? pcsOfItems(item) {
    int isOnceAdded =
        productsInCartCount.indexWhere((element) => element.id == item.id);

    if (isOnceAdded != -1) return productsInCartCount[isOnceAdded].count;
    return 0;
  }

  double totalPayable() {
    double totalPrice = 0.0;
    for (var element in productsInCartList) {
      int pcs = pcsOfItems(element)!;
      totalPrice = totalPrice + (pcs * element.sellingPrice);
    }
    return totalPrice;
  }
}
