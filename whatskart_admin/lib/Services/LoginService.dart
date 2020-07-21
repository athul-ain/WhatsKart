import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatskart_admin/Models/User.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User userFromFirebaseAuth(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(userFromFirebaseAuth);
  }

  //sign in with email
  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      print("Logged in");
      return userFromFirebaseAuth(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
