import 'package:flutter/material.dart';
import 'package:whatskart/models/Product.dart';
import '../config.dart';

class FirebaseServices extends ChangeNotifier {
  Future<String> addProduct(Product product) async {
    var docRef = await productCollectionREF.add({
      'name': product.name,
      'imageURL': product.imageURL,
      'listingPrice': product.listingPrice,
      'sellingPrice': product.sellingPrice,
    });
    return docRef.id;
  }
}
