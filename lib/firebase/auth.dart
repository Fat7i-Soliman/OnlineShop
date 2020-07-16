import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth{
  final auth = FirebaseAuth.instance ;


  Future<AuthResult> signUp(String mail , String pass) async {
    final result = await auth.createUserWithEmailAndPassword(email: mail, password: pass);
    return result ;
  }


  Future<AuthResult> logIn(String mail , String pass) async {
    final result = await auth.signInWithEmailAndPassword(email: mail, password: pass);
    return result ;
  }

  User currentUser (FirebaseUser user)  {
    return user!=null ? User(id: user.uid) : null ;
  }

  Stream<User> get user {
    return auth.onAuthStateChanged.map((event) => currentUser(event));
  }
}