import 'package:cloud_firestore/cloud_firestore.dart';

const String APP_NAME = "WhatsKart";

String whatsapplinkRef =
    "https://api.whatsapp.com/send?phone=919895730558&text=*New%20Order%20%3A*%20*(_TakeAway_)*%20ProductName%20x%20NO1%20Total%20Payable%3A%20*%E2%82%B9680.00*%20*_Address%3A_*%20MyNameANdAddress%208943168465%20Please%20confirm%20via%20reply.%0A%0A%0AHello%20I%20need%20to%20build%20a%20website%20like%20this%2C%20What%27s%20the%20Pricing";

CollectionReference productCollectionREF =
    FirebaseFirestore.instance.collection("products");
