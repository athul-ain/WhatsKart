import 'dart:developer';

class Product {
  late String id;
  late String name;
  late double listingPrice;
  late double sellingPrice;
  late String imageURL;

  Product({
    required String id,
    required String name,
    required double listingPrice,
    required double sellingPrice,
    required String imageURL,
  });

  Product.fromMap(Map thisData) {
    log(thisData.toString());
    name = thisData['name'];
    imageURL = thisData['imageURL'];
    listingPrice = thisData['listingPrice'];
    sellingPrice = thisData['sellingPrice'];
    id = thisData['id'];
  }
}

class ProductCount {
  int count;
  String id;

  ProductCount({required this.count, required this.id});
}
