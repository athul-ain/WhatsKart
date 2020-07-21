import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:whatskart_admin/Models/Products.dart';

class RemoveProductPage extends StatefulWidget {
  @override
  _RemoveProductPageState createState() => _RemoveProductPageState();
}

class _RemoveProductPageState extends State<RemoveProductPage> {
  final _fireRef = Firestore.instance.collection('products');

  List<Product> products = [];
  bool loadingProducts = true;

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  void getProductList() {
    _fireRef.getDocuments().then((value) {
      setState(() {
        products = value.documents.map((e) {
          Product item = new Product();
          item.id = e.documentID;
          item.name = e.data['name'];
          item.imageURL = e.data['imageURL'];
          item.listingPrice = e.data['listingPrice'];
          item.sellingPrice = e.data['sellingPrice'];
          return item;
        }).toList();
        loadingProducts = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remove Product"),
      ),
      body: products.length == 0
          ? Center(
              child: loadingProducts
                  ? CircularProgressIndicator()
                  : Text("Please add product first"),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                Product item = products[i];
                bool deleting = false;
                return ListTile(
                  leading: Card(
                    child: Image.network(
                      item.imageURL,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    "Selling Price: ${item.sellingPrice}\nListing Price: ${item.listingPrice}",
                  ),
                  trailing: deleting
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              deleting = true;
                            });
                            _fireRef.document(item.id).delete().then((value) {
                              Toast.show(
                                  "Product deleted Successfully", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                              getProductList();
                            });
                          },
                        ),
                );
              }),
    );
  }
}
