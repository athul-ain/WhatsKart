import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String appName = "Bootland";
const String shopNumber = "918943891000";
const MaterialColor primaryColor = Colors.brown;
const hidePromoBanner = true;
const String footerAttribute = "Developed by TechNXT";
const String? footerAttributeLink = "https://athul.ain.one";

const String orderType = "Home Delivery";

CollectionReference productCollectionREF =
    FirebaseFirestore.instance.collection("products");
