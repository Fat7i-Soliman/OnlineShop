import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'file:///C:/Users/Fat7y/IdeaProjects/e_commerce/lib/screens/users/user_page.dart';
import 'package:e_commerce/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUpScreen extends StatefulWidget {

  static String id = 'SignUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  String email , pass ;
  final auth = Auth() ;
  bool loading = false ;

  showSnack(String txt){
    _scaffoldState.currentState.showSnackBar(SnackBar(content: Text(txt)));
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height ;

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
                          Text('Welcome to online shop ',style: TextStyle(color: Colors.white),),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height*.05,),
                  CustumTextField(
                  onClick:(value){

                  },
                      hint:'Enter your Name ',
                      icon:Icons.person),
                  SizedBox(height: height*.02,),
                  CustumTextField(
                    onClick:(value) {
                      email = value ;
                    },
                      hint:'Enter your Email',icon:Icons.email),
                  SizedBox(height: height*.02,),

                  CustumTextField(
                    onClick:(value) {
                      pass= value ;
                    },
                      hint:'Enter Password', icon:Icons.lock),
                  SizedBox(height: height*.08,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: FlatButton(
                        onPressed: () async {
                      if(_globalKey.currentState.validate()){
                        // do something
                        setState(() {
                          loading = true ;
                        });
                        try {
                          _globalKey.currentState.save();
                           auth.signUp(email, pass).then((value) => {
                          setState(() {
                          loading = false ;
                          }),

                            Navigator.pushNamedAndRemoveUntil(context, UserPage.id, (route) => false)
                          });

                        }catch(ex){
                          setState(() {
                            loading = false ;
                          });
                          showSnack(ex.message);
                        }
                      }
                    },
                        color: Colors.blueGrey[900],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                  SizedBox(height: height*.01,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('do have an account ?',style: TextStyle(color: Colors.white, fontSize: 16),),
                      SizedBox(width: 5,),

                      GestureDetector(
                          onTap: ()=> {
                            Navigator.pop(context, LoginScreen.id)
                          },
                          child: Text('Login',style: TextStyle(color: Colors.black, fontSize: 16),))

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
