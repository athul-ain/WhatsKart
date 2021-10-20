import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/product_manager.dart';
import '../models/product.dart';
import '../config.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool contentLoading = true;
  bool _displayBanner = !hidePromoBanner;

  List<ProductModel> products = [];

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

        return ProductModel.fromMap(itemData);
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
        title: const Text(appName),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: getProductList,
        child: contentLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _displayBanner
                        ? MaterialBanner(
                            backgroundColor: Colors.grey[100],
                            leading: const CircleAvatar(
                              child: Icon(Icons.local_offer),
                            ),
                            content: const Text(
                              "Need to set up WhatsKart for your Shop/Business?",
                            ),
                            actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() => _displayBanner = false);
                                  },
                                  child: const Text("hide"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String url =
                                        "https://api.whatsapp.com/send?phone=919895730558&text=";
                                    canLaunch(url).then(
                                      (value) => launch(
                                        "${url}Hi%0AI%20am%20intrested%20in%20setting%20up%20*WhatsKart*%20for%20my%20buisiness%0AWhat%20is%20the%20pricing",
                                      ),
                                    );
                                  },
                                  child: const Text("Contact us"),
                                )
                              ])
                        : Container(),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _scrollController,
                      childAspectRatio: 0.7,
                      crossAxisCount: _screenWidth,
                      shrinkWrap: true,
                      children: List.generate(
                        products.length,
                        (i) {
                          ProductModel item = products[i];

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
                                          style: const TextStyle(
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
                                        hoverColor: primaryColor[100],
                                        splashColor: primaryColor[300],
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
                                              const Padding(
                                                padding: EdgeInsets.all(3),
                                              ),
                                              _isOnceAdded
                                                  ? InkWell(
                                                      onTap: () {
                                                        val.substractFromCart(
                                                            item);
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
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
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
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
                          onPressed: footerAttributeLink == null
                              ? null
                              : () async {
                                  await launch(footerAttributeLink!);
                                },
                          child: const Text(footerAttribute),
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
          showBadge: val.productsInCartList.isEmpty ? false : true,
          child: FloatingActionButton(
            onPressed: _openAddEntryDialog,
            tooltip: 'Cart',
            child: const Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }

  void _openAddEntryDialog() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const CartPage();
        },
        fullscreenDialog: true,
      ),
    );
  }
}
