import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/screens/admin/add_product.dart';
import 'package:e_commerce/screens/admin/categories_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login_screen.dart';
class AdminPage extends StatefulWidget {

  static String id = 'AdminPage';
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: double.infinity,),
              RaisedButton(
                  onPressed: ()=>{
                    Navigator.pushNamed(context, AddProduct.id)
                  },
                child: Text('Add Product'),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                onPressed: ()=>{
                  Navigator.pushNamed(context, EditProduct.id)
                },
                child: Text('Edit Product'),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                onPressed: null,
                child: Text('View Orders'),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                onPressed: ()=> showAlertDialog(context),
                child: Text('Log out'),
              ),

            ],
          )
      ),
    );


  }

  logOut(context){
    Auth().auth.signOut().then((value) => Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false));
  }



  Future showAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Log Out !'),
          content: Text('Are you sure you want to exit ?'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  logOut(context);
                },
                child: Text('Log out')),
            FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text('cancel')),

          ],
        )
    );
  }
}
