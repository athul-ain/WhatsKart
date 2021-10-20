import 'package:flutter/material.dart';
import 'package:whatskart/models/product.dart';
import '../config.dart';

class FirebaseServices extends ChangeNotifier {
  Future<String> addProduct(ProductModel product) async {
    var docRef = await productCollectionREF.add({
      'name': product.name,
      'imageURL': product.imageURL,
      'listingPrice': product.listingPrice,
      'sellingPrice': product.sellingPrice,
    });
    return docRef.id;
  }
}
