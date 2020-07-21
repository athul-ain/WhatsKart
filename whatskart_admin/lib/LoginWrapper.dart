import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatskart_admin/Pages/home.dart';
import 'package:whatskart_admin/Pages/login.dart';
import 'Models/User.dart';

class LoginWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return LoginPage();
      //return HomePage();
    } else {
      return HomePage();
    }
  }
}
