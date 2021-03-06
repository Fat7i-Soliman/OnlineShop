import 'dart:io';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/global_productID.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/widgets/custom_textField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:e_commerce/constants.dart';


class EditPage extends StatefulWidget {

  static String id = 'EditPage';
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  Product product;
  final _picker = ImagePicker();
  File _image;
  String _uploadedFileURL;

  List<PopupMenuEntry<Women>> womenCat = List<PopupMenuEntry<Women>>();
  List<PopupMenuEntry<Men>> menCat = List<PopupMenuEntry<Men>>();

  String genderMen = 'men';
  String genderWomen = 'women';
  String genderValue ;

  var _categoryValue ;
  bool selected  ;

  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Store fireStore = Store();
  String name , price, des, category, image, path ;
  bool saving = false ;


  Future showAlertDialog(BuildContext context) async{
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Delete !'),
        content: Text('Are you sure ?'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
            fireStore.deleteProduct(product.id,product);
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
  void initState() {
    product = GlobalProductId.instance.get() ;
    path = product.path;
    _uploadedFileURL = product.image;
    selected = true ;
    category = product.category ;
    _categoryValue= 'you choose ${product.category}';

    genderValue= product.gender;
    chooseCategory();
    super.initState();
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
                          title: Text('change image '),
                          subtitle: path !=null? Text(path): Text(""),
                           onTap: ()=> getImage(),
                        ),
                        SizedBox(height: 20,),

                        RaisedButton(
                          onPressed: () async {
                            if(_globalKey.currentState.validate()){

                              if(selected) {
                                setState(() {
                                  saving = true;
                                });
                                _globalKey.currentState.save();

                                if(_image!=null){
                                  await uploadFile();
                                }
                                product.name = name;
                                product.price = price;
                                product.description = des;
                                product.category = category;
                                product.image = _uploadedFileURL;
                                product.gender = genderValue;
                                product.path = path ;

                                fireStore.editProduct(product, product.id);
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('changes Saved'),
                                  duration: Duration(seconds: 1),));

                                setState(() {
                                  saving = false;
                                });
                              }else{
                                setState(() {
                                  saving = false;
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('choose category'),
                                  duration: Duration(seconds: 1),));
                              }
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
    print(cat.toString());
    int index = cat.toString().indexOf('.');
    index++;
    return cat.toString().substring(index);
  }

  changeGender(value){
    setState(() {
      genderValue = value ;
      _categoryValue = 'Choose a category';
      selected=false;
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
      print('image done : $path ${_image.path}');


    }catch( ex){
      print('image : ${ex.message}');
    }

  }

  Future uploadFile() async {

    await FirebaseStorage.instance
        .ref()
        .child('productImages/${product.path}').delete().catchError((onError){
          print('error delete ${onError.message}' );
    });

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
}
