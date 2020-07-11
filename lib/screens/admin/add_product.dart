import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/widgets/custom_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class AddProduct extends StatefulWidget {
  static String id = 'AddProduct';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Store fireStore = Store();
  String id,name , price, des, category, image ;
  bool adding = false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    ListTile(
                      leading: Icon(Icons.add_a_photo),
                      title: Text('Add Product Images'),
                      onTap: loadAssets,
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

                              _globalKey.currentState.reset();
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Added')));

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

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarColor: '#78909C',
          actionBarTitle: "Shoping online",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });

    print('images count ${images.length}');
    print('error $_error');

  }
}
