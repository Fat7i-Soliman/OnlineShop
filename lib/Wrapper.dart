import 'package:e_commerce/screens/admin/admin_page.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/screens/users/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

      final user = Provider.of<User>(context);

      if(user==null){
        return LoginScreen() ;
      }else{
        if(user.id=='ylIBZIJVFcNzu8Zdf0ItudL0naW2'){
          return AdminPage();
        }else{
          return UserPage();
        }
      }
  }
}
