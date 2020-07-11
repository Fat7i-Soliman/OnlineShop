import 'package:e_commerce/screens/admin/admin_page.dart';
import 'package:e_commerce/screens/user_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:e_commerce/widgets/custom_textField.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  final adminPass = 'admin1234';

  String email , pass ;
  final auth = Auth() ;
  bool loading=false ;
  bool isAdmin = false ;

  showSnack(String txt){
    _scaffoldState.currentState.showSnackBar(SnackBar(content: Text(txt)));
  }
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;


    login() async {
      if(_globalKey.currentState.validate()) {
        setState(() {
          loading = true;
        });

        // do something
        _globalKey.currentState.save();

        if (isAdmin) {

          if(adminPass == pass){
            try {
              await auth.logIn(email, pass).whenComplete(() => Navigator.pushNamed(context, AdminPage.id));
              setState(() {
                loading = false;
              });


              // navigate to admin account

            } catch (ex) {
              setState(() {
                loading = false;
              });              showSnack(ex.message);
            }
          }else{
            showSnack('you are not an admin !');
            setState(() {
              loading = false;
            });          }
        } else {
          if (!email.contains('eshop.com')){
            try {
              await auth.logIn(email, pass).then((value) =>
              {

                setState(() {
                  loading = false;
                }),

                Navigator.pushNamed(context, UserPage.id)
              }
              );

            // navigate to user account

          } catch (ex) {
            setState(() {
              loading = false;
            });
            showSnack(ex.message);
          }
        }else{
            showSnack('that is an admin account!');
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      key: _scaffoldState,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: loading,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blueGrey[200],Colors.blueGrey[500]],begin: Alignment.bottomCenter ,end: Alignment.topCenter)
            ),
            child: Form(
              key: _globalKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: height*.01,),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 70),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                         // Image(image: AssetImage('images/icons/shopping.png'),height: 100,width: 100,),
                          Text('Online Shop',style: TextStyle(fontFamily: 'Pacifico',fontSize: 50,color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height*.05,),
                  CustumTextField(
                    onClick: (value){
                      email= value ;
                    },
                      hint:'Enter your Email',icon:Icons.email),
                  SizedBox(height: height*.02,),

                  CustumTextField(
                      onClick: (value){
                        pass= value ;
                      },
                      hint:'Enter Password',icon: Icons.lock),
                  SizedBox(height: height*.08,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: FlatButton(onPressed: login,
                        color: Colors.blueGrey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                  SizedBox(height: height*.01,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('don\'t have an account ?',style: TextStyle(color: Colors.white, fontSize: 16),),
                      SizedBox(width: 5,),

                      GestureDetector(
                        onTap: ()=> {
                          Navigator.pushNamed(context, SignUpScreen.id)
                        },
                          child: Text('Sign Up',style: TextStyle(color: Colors.black, fontSize: 16),))

                    ],
                  ),
                  SizedBox(height: height*.01,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isAdmin = !isAdmin ;
                      });
                    },
                    child: Text(
                        isAdmin==false?'I\'m an admin ': 'I\'m a user',
                      style: TextStyle(color: Colors.white ,fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: height*.01,),


                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}


