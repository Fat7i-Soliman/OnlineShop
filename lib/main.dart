import 'package:e_commerce/screens/admin/add_product.dart';
import 'package:e_commerce/screens/admin/admin_page.dart';
import 'package:e_commerce/screens/admin/edit_page.dart';
import 'package:e_commerce/screens/admin/edit_priduct.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:e_commerce/screens/user_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.id,
debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.id: (BuildContext context)=> LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        AdminPage.id : (context)=> AdminPage(),
        AddProduct.id : (context)=> AddProduct(),
        EditProduct.id:(context)=> EditProduct(),
        EditPage.id : (context) => EditPage(),
        UserPage.id : (context)=> UserPage()
      },

    );
  }
}

