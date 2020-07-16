import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/provider/cart_items.dart';
import 'package:e_commerce/screens/admin/add_product.dart';
import 'package:e_commerce/screens/admin/admin_page.dart';
import 'package:e_commerce/screens/admin/edit_page.dart';
import 'package:e_commerce/screens/admin/categories_page.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:e_commerce/screens/users/cart_screen.dart';
import 'package:e_commerce/screens/users/details_screen.dart';
import 'package:e_commerce/screens/users/single_category.dart';
import 'file:///C:/Users/Fat7y/IdeaProjects/e_commerce/lib/screens/users/user_page.dart';
import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CartItems>(create: (context)=> CartItems())
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        SingleCategory.id:(context)=>SingleCategory(),
        LoginScreen.id: (context)=> LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        AdminPage.id : (context)=> AdminPage(),
        AddProduct.id : (context)=> AddProduct(),
        EditProduct.id:(context)=> EditProduct(),
        EditPage.id : (context) => EditPage(),
        UserPage.id : (context)=> UserPage(),
        DetailsScreen.id:(context)=> DetailsScreen(),
        CartScreen.id: (context)=> CartScreen()
      },
      home: MainPage(),
    ),
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Auth _auth ;

  Map<String, Widget> op = {'null': LoginScreen(), 'admin': AdminPage(),'user':UserPage()};

  checkUser()async {
    _auth = Auth();
    await _auth.currentUser().then((value) {
//      if (value == null) {
//        setState(() {
//          _state = 'null';
//        });
//
//      } else {
//        var mail = value.email;
//        if (mail == 'admin1@eshop.com') {
//          setState(() {
//            _state = 'admin';
//
//          });
//        } else {
//          setState(() {
//            _state = 'user';
//          });
//        }
//      }
    }
    );
  }


  @override
  void initState() {
    //checkUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return CustomSplash(
      imagePath: 'images/icons/shop_app.png',
      backGroundColor: Colors.blueGrey,
      animationEffect: 'zoom-in',
      logoSize: 100,
      home:LoginScreen() ,
      duration: 2000,
      type: CustomSplashType.StaticDuration,
    );
  }
}
