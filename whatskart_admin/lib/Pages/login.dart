import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:whatskart_admin/Services/LoginService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login to WK Admin Panel"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(7),
                width: 353,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(7),
                width: 353,
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                child: Text(loading ? "..." : "Login"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    Toast.show("Logging in", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

                    String email = emailController.text;
                    String password = passwordController.text;

                    dynamic result =
                        await LoginService().signInWithEmail(email, password);
                    if (result == null) {
                      setState(() => loading = false);
                      Toast.show("Loggin Failed", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
