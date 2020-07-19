import 'package:flutter/material.dart';
class CustumTextField extends StatelessWidget {
  String hint ;
  IconData icon ;
  Function onClick ;
  String txt ;
  final _controller  = TextEditingController();

  CustumTextField({@required this.onClick,@required this.hint, this.icon,this.txt});

  @override
  Widget build(BuildContext context) {

    if(txt!=null){
      _controller.text = txt ;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,),
      child: TextFormField(
        controller:txt!=null? _controller: null,
        validator: (value){
          if(value.isEmpty){
            return 'Field is empty';
          }else{
            _controller.text = value ;
          }
          // ignore: missing_return
        },
        onSaved: onClick,
        obscureText: hint =='Enter Password'? true :false ,
        decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon,color: Colors.blueGrey,),
            filled: true,
            fillColor: Colors.blueGrey[50],
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.white,

                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.white,

                )
            ),
          border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                              color: Colors.white,
                  ))
        ),
      ),
    );
  }
}