import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatskart_admin/LoginWrapper.dart';
import 'package:whatskart_admin/Models/User.dart';
import 'package:whatskart_admin/Services/LoginService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: LoginService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WK Admin Panel',
        theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            color: Color.fromRGBO(7, 94, 84, 1),
          ),
        ),
        home: LoginWrapper(),
      ),
    );
  }
}
