import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatskart/config.dart';
import '../Services/product_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileNumberController = TextEditingController();

  LineSplitter ls = const LineSplitter();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _screenWidth = (MediaQuery.of(context).size.width).toInt();

    return Consumer<ProductManager>(
      builder: (context, val, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Check out"),
          ),
          body: val.productsInCartCount.isEmpty
              ? const Center(
                  child: Text("Your Cart is empty"),
                )
              : ListView(
                  controller: _scrollController,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: const ScrollPhysics(),
                      itemCount: val.productsInCartCount.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: SizedBox(
                            width: 88,
                            child: Card(
                              child: Image.network(
                                val.productsInCartList[i].imageURL,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          title: Text(val.productsInCartList[i].name),
                          subtitle: Row(
                            children: [
                              Text(
                                  "₹${val.productsInCartList[i].sellingPrice}  x"),
                              InkWell(
                                onTap: () {
                                  val.substractFromCart(
                                      val.productsInCartList[i]);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.remove_circle,
                                  ),
                                ),
                              ),
                              Text(val
                                  .pcsOfItems(val.productsInCartList[i])
                                  .toString()),
                              InkWell(
                                onTap: () {
                                  val.addToCart(val.productsInCartList[i]);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.add_circle,
                                  ),
                                ),
                              ),
                              Text(
                                "= ₹${val.pcsOfItems(val.productsInCartList[i])! * val.productsInCartList[i].sellingPrice}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          trailing: _screenWidth < 335
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    val.removeFromCart(
                                        val.productsInCartList[i]);
                                  },
                                ),
                        );
                      },
                    ),
                    Card(
                      elevation: 0.5,
                      child: ListTile(
                        title: Text(
                          "Total Amount",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        trailing: Text(
                          "₹${val.totalPayable()}",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Padding(padding: EdgeInsets.all(5)),
                          Container(
                            padding: const EdgeInsets.all(7),
                            width: 353,
                            child: TextFormField(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: "Enter your Name *",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'name cannot be empty';
                                } else if (value.length < 3) {
                                  return 'Please enter a valid name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(7),
                            width: 353,
                            child: TextFormField(
                              controller: mobileNumberController,
                              maxLength: 10,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: "Enter your Mobile Number *",
                                prefixText: "+91 ",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'mobile number cannot be empty';
                                } else if (value.length != 10) {
                                  return 'Please enter a valid mobile number';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(7),
                            width: 353,
                            child: TextFormField(
                              controller: addressController,
                              minLines: 2,
                              maxLines: 5,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                labelText: "Enter your Address *",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'address cannot be empty';
                                } else if (value.length < 3) {
                                  return 'Please enter a valid address';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(50))
                  ],
                ),
          floatingActionButton: val.productsInCartCount.isEmpty
              ? Container()
              : FloatingActionButton.extended(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      checkoutWhatsApp(val);
                    } else {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Checkout"),
                ),
        );
      },
    );
  }

  checkoutWhatsApp(val) {
    double totalPrice = 0.0;
    String productsDetailText = "";

    String url = "https://api.whatsapp.com/send?phone=$shopNumber&text=";

    val.productsInCartList.forEach((element) {
      int pcs = val.pcsOfItems(element);
      totalPrice = totalPrice + (pcs * element.sellingPrice);
      productsDetailText =
          "$productsDetailText${element.name}%20₹${element.sellingPrice}%20x%20${pcs}Qty%3A%20*₹${pcs * element.sellingPrice}*%0A";
    });

    String typeOfOrder = "*New%20Order%20%3A*%20*(_${orderType}_)*%0A";

    String totalPriceText = "*Total%20Payable%3A%20₹$totalPrice*%0A%0A";

    String _address = "";
    for (var line in ls.convert(addressController.text)) {
      _address = _address + line + "%0A";
    }
    String addressText =
        "*_Address%3A_*%0A${nameController.text}%0A$_address${mobileNumberController.text}%0A";

    // String promotionalText =
    //     "%0A%0A%0AHello%20I%20need%20to%20build%20a%20website%20like%20this%2C%20What%27s%20the%20Pricing";

    canLaunch(url).then((value) {
      launch(url +
          typeOfOrder +
          productsDetailText +
          totalPriceText +
          addressText +
          "%0APlease%20confirm%20via%20reply.");
    });
  }
}
