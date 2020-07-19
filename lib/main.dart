import 'package:e_commerce/Wrapper.dart';
import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/models/user.dart';
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
import 'package:e_commerce/screens/users/user_page.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      StreamProvider<User>.value(
          value: Auth().user,
      ),
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
        CartScreen.id: (context)=> CartScreen(),
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

  @override
  Widget build(BuildContext context) {

    return SplashScreen(
        seconds: 2,
        navigateAfterSeconds: Wrapper(),
        title: new Text('Welcome In Online Shop',style: TextStyle(fontFamily: 'Pacifico',fontSize: 25,color: Colors.white)),
        image: new Image.asset('images/icons/shop_app.png'),
        //backgroundColor: Colors.blueGrey,
        gradientBackground:LinearGradient(colors: [Colors.blueGrey[400],Colors.blueGrey[800]],begin: Alignment.bottomCenter ,end: Alignment.topCenter) ,
        //styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.blueGrey[400]
    );


  }

}
