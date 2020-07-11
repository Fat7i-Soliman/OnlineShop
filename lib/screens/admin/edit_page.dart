import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/global_productID.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/admin/edit_priduct.dart';
import 'package:e_commerce/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditPage extends StatefulWidget {

  static String id = 'EditPage';
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  Product product = GlobalProductId.instance.get() ;

  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Store fireStore = Store();
  String name , price, des, category, image ;
  bool saving = false ;


  Future showAlertDialog(BuildContext context) async{
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Delete !'),
        content: Text('Are you sure ?'),
        actions: <Widget>[
          FlatButton(
              onPressed: (){
            fireStore.deleteProduct(product.id);
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Deleted'),duration: Duration(seconds: 1)));
            Navigator.pop(context);
            Navigator.pop(context);

              },
              child: Text('delete')),
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('cancel')),

        ],
      )
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
            onPressed: (){
                showAlertDialog(context);
            },

          )
        ],
      ),
      body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: saving,
            child: Form(
              key: _globalKey,
              child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30,),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Edit Product',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),

                        CustumTextField(
                          txt: product.name,
                          hint: 'product name',
                          onClick: (value){
                            name = value ;

                          },

                        ),
                        SizedBox(height: 20,),
                        CustumTextField(
                          txt: product.price,

                          hint: 'product price',
                          onClick: (value){
                            price = value ;

                          },
                        ),
                        SizedBox(height: 20,),

                        CustumTextField(
                          txt: product.description,

                          hint: 'product decription',
                          onClick: (value){
                            des = value ;

                          },
                        ),
                        SizedBox(height: 20,),

                        CustumTextField(
                          txt: product.category,

                          hint: 'product category',
                          onClick: (value){
                            category = value ;

                          },
                        ),
                        SizedBox(height: 20,),

                        CustumTextField(
                          txt: product.image,

                          hint: 'product image',
                          onClick: (value){
                            image = value ;
                          },
                        ),
                        SizedBox(height: 20,),
                        ListTile(
                          leading: Icon(Icons.add_a_photo),
                          title: Text('Add Product Images'),
                         // onTap: loadAssets,
                        ),
                        SizedBox(height: 20,),

                        RaisedButton(
                          onPressed: (){
                            if(_globalKey.currentState.validate()){

                              setState(() {
                                saving = true ;
                              });
                              _globalKey.currentState.save();

                              product.name = name;
                              product.price = price;
                              product.description= des ;
                              product.category = category ;
                              product.image = image ;

                              fireStore.editProduct(product, product.id);
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('changes Saved'),duration: Duration(seconds: 1),));

                              setState(() {
                                saving = false ;
                              });
                            }
                          },
                          child: Text('Save Product'),

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
