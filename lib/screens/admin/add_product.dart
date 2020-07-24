import 'dart:io';

import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/widgets/custom_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_commerce/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProduct extends StatefulWidget {
  static String id = 'AddProduct';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final _picker = ImagePicker();
  File _image;
  String _uploadedFileURL;
  String path ;

  List<PopupMenuEntry<Women>> womenCat = List<PopupMenuEntry<Women>>();
  List<PopupMenuEntry<Men>> menCat = List<PopupMenuEntry<Men>>();

  String genderMen = 'men';
  String genderWomen = 'women';
  String genderValue ='men';

  String _categoryValue = 'Choose a category';
  bool selected  ;
  
  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Store fireStore = Store();
  String id,name , price, des, category, image ;
  bool adding = false ;


  @override
  void initState() {
    selected=false ;
    chooseCategory();
    super.initState();
  }

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
                    makeRadios(),
                    SizedBox(height: 20,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_categoryValue),
                          SizedBox(width: 20,),
                          makeMenu()
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    ListTile(
                      leading: Icon(Icons.add_a_photo),
                      title: Text('Add Product Image'),
                      subtitle: path!=null? Text(path): Text(""),
                      onTap: (){
                        getImage();
                      },
                    ),
                    SizedBox(height: 20,),


                    RaisedButton(
                        onPressed: () async{
                          if(_globalKey.currentState.validate()){

                            if(selected) {

                              if(_image!=null){

                                setState(() {
                                  adding = true;
                                });
                                _globalKey.currentState.save();
                                await uploadFile();
                                try {
                                  fireStore.addProduct(Product(
                                      name: name,
                                      description: des,
                                      price: price,
                                      gender: genderValue,
                                      category: category,
                                      image: _uploadedFileURL,
                                      path: path
                                  ));

                                  setState(() {
                                    adding = false;
                                  });

                                  reset();
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text('Added')));
                                } catch (ex) {
                                  print(ex.message);
                                }
                              }else{
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('select image !'),
                                  duration: Duration(milliseconds: 500),));
                              }

                            }else{
                              setState(() {
                                adding = false;
                              });
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('choose category'),
                                duration: Duration(seconds: 1),));
                            }
                          }
                        },
                      child: Text('Add Product'),

                    ),
                    SizedBox(height: 30,)

                  ],
                ),
              ]
              ),
            ),
          )
      ),
    );
  }


  Widget makeMenu(){
    if(genderValue==genderMen){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: PopupMenuButton(
            onSelected: onSelectCat,
            child: Icon(Icons.input),
            initialValue: Men.t_shirt,
            itemBuilder: (context){
          return menCat ;
        }),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: PopupMenuButton(
          onSelected: onSelectCat,
            child: Icon(Icons.input),
            initialValue: Women.dressesWomen,
            itemBuilder: (context){
              return womenCat ;
            }),
      );
    }
  }

  chooseCategory(){
    for (Men men in Men.values){
      menCat.add(PopupMenuItem(child: Text(_getDisplay(men)),value: men,));
    }

    for (Women women in Women.values){
      womenCat.add(PopupMenuItem(child: Text(_getDisplay(women)),value: women,));
    }
  }

  onSelectCat(value){
    setState(() {
      selected = true ;
      _categoryValue = 'you choose ${_getDisplay(value)}';
      category = _getDisplay(value) ;

    });
  }

  String _getDisplay(var cat) {
    int index = cat.toString().indexOf('.');
    index++;
    return cat.toString().substring(index);
  }

  changeGender(value){
    setState(() {
      genderValue = value ;
      _categoryValue = 'Choose a category';
    });
  }

  //  gender radios
  Widget makeRadios(){

    List<Widget> list = List();

    list.add(Expanded(child: new RadioListTile(value: genderMen, groupValue: genderValue, onChanged: changeGender,title: Text(genderMen),)));
    list.add(Expanded(child: new RadioListTile(value: genderWomen, groupValue: genderValue, onChanged: changeGender,title: Text(genderWomen),)));

    Row row = new Row(children: list,crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceAround,);
    return Container(child: row,//padding: EdgeInsets.symmetric(horizontal: 30),
      width: 290,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(20)
    ),
    );
  }

  Future getImage() async {
    try {
      final PickedFile pickedFile = await _picker.getImage(
          source: ImageSource.gallery);

      setState(() {
        _image = File(pickedFile.path);
        path = _image.path.split('/').last ;

      });


    }catch(ex){

    }
  }

  Future uploadFile() async {

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('productImages/$path');

    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL.toString();
      });
      print('File url $_uploadedFileURL');

    });
  }

   reset() {
      _image = null ;
      _uploadedFileURL = null ;
      path = null ;
      _categoryValue = 'Choose a category';
      selected = false ;
     _globalKey.currentState.reset();
   }

}
