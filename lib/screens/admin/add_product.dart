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

enum Men{t_shirt,shirt,sweaters,jackets,blazers,Pants,shoes,sunGlasses}
enum Women{dressesWomen,blousesWomen,beautyWomen,PantsWomen,blazersWomen,shoesWomen,bagsWomen}

class _AddProductState extends State<AddProduct> {
  String _error = 'No Error Dectected';

  List<Asset> images = List<Asset>();

  List<PopupMenuEntry<Women>> womenCat = List<PopupMenuEntry<Women>>();
  List<PopupMenuEntry<Men>> menCat = List<PopupMenuEntry<Men>>();

  String genderMen = 'men';
  String genderWomen = 'women';
  String genderValue ='men';

  String _categoryValue = 'Choose a category';
  var selected  ;
  
  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Store fireStore = Store();
  String id,name , price, des, category, image ;
  bool adding = false ;


  @override
  void initState() {
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
                                  gender: genderValue,
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
      selected = value ;
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
