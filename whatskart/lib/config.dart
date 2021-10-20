import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String appName = "WhatsKart";
const String shopNumber = "919895730558";
const MaterialColor primaryColor = Colors.green;
const hidePromoBanner = true;
const String footerAttribute = "Developed by athul.ain.one";
const String? footerAttributeLink = "https://athul.ain.one";

CollectionReference productCollectionREF =
    FirebaseFirestore.instance.collection("products");
