import 'dart:developer';

class ProductModel {
  late String id;
  late String name;
  late double listingPrice;
  late double sellingPrice;
  late String imageURL;

  ProductModel({
    required String id,
    required String name,
    required double listingPrice,
    required double sellingPrice,
    required String imageURL,
  });

  ProductModel.fromMap(Map thisData) {
    log(thisData.toString());
    name = thisData['name'];
    imageURL = thisData['imageURL'];
    listingPrice = thisData['listingPrice'];
    sellingPrice = thisData['sellingPrice'];
    id = thisData['id'];
  }
}

class ProductCountModel {
  int count;
  String id;

  ProductCountModel({required this.count, required this.id});
}
