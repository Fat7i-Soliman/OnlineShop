import 'package:firebase_auth/firebase_auth.dart';
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
}