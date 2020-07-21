import 'package:flutter/material.dart';
import 'package:whatskart_admin/Pages/AddProductPage.dart';
import 'package:whatskart_admin/Pages/RemoveProductPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wk Admin Panel"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Add Product"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProductPage()));
            },
          ),
          ListTile(
            title: Text("Remove a Product"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RemoveProductPage()));
            },
          ),
        ],
      ),
    );
  }
}
