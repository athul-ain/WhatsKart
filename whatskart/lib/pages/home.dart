import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/ProductManager.dart';
import '../models/Product.dart';
import '../config.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  bool contentLoading = true;
  bool _displayBanner = true;

  List<Product> products = [];

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  Future getProductList() async {
    final value = await productCollectionREF.get();

    setState(() {
      products = value.docs.map((e) {
        Map itemData = e.data() as Map;
        itemData["id"] = e.id;

        return Product.fromMap(itemData);
      }).toList();

      contentLoading = false;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    int _screenWidth = (MediaQuery.of(context).size.width ~/ 158).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: Color.fromRGBO(0, 191, 165, 1),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getProductList,
        child: contentLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _displayBanner
                        ? MaterialBanner(
                            backgroundColor: Colors.grey[100],
                            leading: CircleAvatar(
                              child: Icon(Icons.local_offer),
                            ),
                            content: Text(
                              "Need to set up WhatsKart for your Shop/Business?",
                            ),
                            actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() => _displayBanner = false);
                                  },
                                  child: Text("hide"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String url =
                                        "https://api.whatsapp.com/send?phone=91$SHOP_NUMBER&text=";
                                    canLaunch(url).then(
                                      (value) => launch(
                                        "${url}Hi%0AI%20am%20intrested%20in%20setting%20up%20*WhatsKart*%20for%20my%20buisiness%0AWhat%20is%20the%20pricing",
                                      ),
                                    );
                                  },
                                  child: Text("Contact us"),
                                )
                              ])
                        : Container(),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _scrollController,
                      childAspectRatio: 0.7,
                      crossAxisCount: _screenWidth,
                      shrinkWrap: true,
                      children: List.generate(
                        products.length,
                        (i) {
                          Product item = products[i];

                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    item.imageURL,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    item.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "₹${item.sellingPrice} ",
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w600),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "₹${item.listingPrice}",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Consumer<ProductManager>(
                                  builder: (context, val, child) {
                                    bool _isOnceAdded = -1 !=
                                        val.productsInCartList.indexWhere(
                                            (element) => element.id == item.id);

                                    return FractionallySizedBox(
                                      widthFactor: 1,
                                      child: InkWell(
                                        hoverColor: Colors.green[100],
                                        splashColor: Colors.green[300],
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Icon(_isOnceAdded
                                                    ? Icons.shopping_cart
                                                    : Icons.add_shopping_cart),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(3),
                                              ),
                                              _isOnceAdded
                                                  ? InkWell(
                                                      onTap: () {
                                                        val.substractFromCart(
                                                            item);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Icon(
                                                          Icons.remove_circle,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              Text(
                                                _isOnceAdded
                                                    ? val
                                                        .pcsOfItems(item)
                                                        .toString()
                                                    : "Add to Cart",
                                              ),
                                              _isOnceAdded
                                                  ? InkWell(
                                                      onTap: () {
                                                        val.addToCart(item);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Icon(
                                                          Icons.add_circle,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                        onTap: _isOnceAdded
                                            ? null
                                            : () {
                                                val.addToCart(item);
                                              },
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: Center(
                        child: TextButton(
                          style:
                              TextButton.styleFrom(primary: Colors.orange[600]),
                          onPressed: () async {
                            await launch("https://athul.ain.one");
                          },
                          child: Text("Developed by athul.ain.one"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: Consumer<ProductManager>(
        builder: (context, val, child) => Badge(
          animationType: BadgeAnimationType.scale,
          badgeContent: Text(val.productsInCartList.length.toString()),
          showBadge: val.productsInCartList.length == 0 ? false : true,
          child: FloatingActionButton(
            onPressed: _openAddEntryDialog,
            tooltip: 'Cart',
            child: Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }

  void _openAddEntryDialog() {
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return CartPage();
        },
        fullscreenDialog: true,
      ),
    );
  }
}
