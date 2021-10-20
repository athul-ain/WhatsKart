import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:toast/toast.dart';
import 'package:whatskart_admin/Models/Products.dart';
import 'package:whatskart_admin/Services/DatabaseServices.dart';
import 'package:firebase/firebase.dart' as fb;

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final listingPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  bool loading = false;
  bool imageUploadDone = false;
  String uploadStatus = "pending upload";
  var random = new Random();

  MediaInfo _image;

  Future<MediaInfo> imagePicker() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getImageInfo;
    setState(() {
      _image = mediaInfo;
    });
    return mediaInfo;
  }

  Future<Uri> uploadFile() async {
    String fileName =
        "productimage${DateTime.now().millisecondsSinceEpoch.toString()}${random.nextInt(88)}";
    try {
      fb.StorageReference storageReference =
          fb.storage().ref("images").child(fileName + ".png");

      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await storageReference.put(_image.data).future;

      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      print("download url $imageUri");
      return imageUri;
    } catch (e) {
      print("File Upload Error $e");
      print(e.toString());
      return null;
    }
  }

  void uploadProduct(BuildContext context) {
    if (_formKey.currentState.validate() &&
        _image != null &&
        loading == false) {
      setState(() {
        uploadStatus = "uploading image";
        loading = true;
      });

      uploadFile().then((value) {
        setState(() => imageUploadDone = true);
        Product item = new Product();
        item.imageURL = value.toString();
        item.name = nameController.text;
        item.listingPrice = double.parse(listingPriceController.text);
        item.sellingPrice = double.parse(sellingPriceController.text);

        FirebaseServices().addProduct(item).then((value) {
          Toast.show("Upload Completed Successfully", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          print(value.toString());
          nameController.clear();
          listingPriceController.clear();
          sellingPriceController.clear();
          setState(() {
            loading = false;
            _image = null;
            imageUploadDone = false;
          });
        });
      });
    } else if (_image == null) {
      Toast.show("Please Choose an image to upload", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Product"),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Container(
                      width: 353,
                      child: _image == null
                          ? Center(
                              child: MaterialButton(
                                onPressed: () => imagePicker(),
                                child: Text("pick an image"),
                              ),
                            )
                          : Column(
                              children: [
                                Image.memory(_image.data),
                                Text(_image.fileName),
                                Text("Upload Status: $uploadStatus")
                              ],
                            ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    width: 353,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please the product name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    width: 353,
                    child: TextFormField(
                      controller: listingPriceController,
                      decoration: InputDecoration(
                        labelText: "Listing Price",
                        border: OutlineInputBorder(),
                        prefixText: "₹",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please the product Listing Price';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    width: 353,
                    child: TextFormField(
                      controller: sellingPriceController,
                      decoration: InputDecoration(
                        labelText: "Selling Price",
                        prefixText: "₹",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please the product Selling Price';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    child: Text(loading ? "..." : "Add Product"),
                    onPressed: loading
                        ? () {}
                        : () async {
                            uploadProduct(context);
                          },
                  ),
                  // StreamBuilder<fb.UploadTaskSnapshot>(
                  //   //Clean
                  //   stream: _uploadTask?.onStateChanged,
                  //   builder: (context, snapshot) {
                  //     final event = snapshot?.data;

                  //     // Default as 0
                  //     double progressPercent = event != null
                  //         ? event.bytesTransferred / event.totalBytes * 100
                  //         : 0;

                  //     if (progressPercent == 100) {
                  //       return Text('Successfully uploaded file 🎊');
                  //     } else if (progressPercent == 0) {
                  //       return SizedBox();
                  //     } else {
                  //       return LinearProgressIndicator(
                  //         value: progressPercent,
                  //       );
                  //     }
                  //   },
                  // ),
                ],
              ),
            )),
      ),
    );
  }
}
