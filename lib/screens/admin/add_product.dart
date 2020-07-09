import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/widgets/custom_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class AddProduct extends StatefulWidget {
  static String id = 'AddProduct';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
  Store fireStore = Store();
  String name , price, des, category, image ;
  bool adding = false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: adding,
            child: Form(
              key: _globalKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 50,),

                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Add new Product',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),

                    CustumTextField(
                      hint: 'product name',
                      onClick: (value){
                        name = value ;

                      },

                    ),
                    SizedBox(height: 20,),
                    CustumTextField(
                      hint: 'product price',
                      onClick: (value){
                        price = value ;

                      },
                    ),
                    SizedBox(height: 20,),

                    CustumTextField(
                      hint: 'product decription',
                      onClick: (value){
                        des = value ;

                      },
                    ),
                    SizedBox(height: 20,),

                    CustumTextField(
                      hint: 'product category',
                      onClick: (value){
                        category = value ;

                      },
                    ),
                    SizedBox(height: 20,),

                    CustumTextField(
                      hint: 'product image',
                      onClick: (value){
                        image = value ;
                      },
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                        onPressed: (){
                          if(_globalKey.currentState.validate()){

                            setState(() {
                              adding = true ;
                            });
                            _globalKey.currentState.save();
                            try {
                              fireStore.addProduct(Product(
                                  name: name,
                                  description: des,
                                  price: price,
                                  category: category,
                                  image: image
                              ));

                              setState(() {
                                adding = false ;
                              });
                             // _globalKey.currentState.reset();

                            }catch(ex){
                              print(ex.message);
                            }

                          }
                        },
                      child: Text('Add Product'),

                    )

                  ],
                ),
              ]
              ),
            ),
          )
      ),
    );
  }
}
