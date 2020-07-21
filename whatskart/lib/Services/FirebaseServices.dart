import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatskart/models/Product.dart';

class FirebaseServices extends ChangeNotifier {
  Future<String> addProduct(Product product) async {
    final products = Firestore.instance.collection('products');

    var docRef = await products.add({
      'name': product.name,
      'imageURL': product.imageURL,
      'listingPrice': product.listingPrice,
      'sellingPrice': product.sellingPrice,
    });
    return docRef.documentID;
  }
}
