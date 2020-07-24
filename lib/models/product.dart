import 'package:e_commerce/constants.dart';

class Product{

  String id ,name,price, description,category,image,gender,path;

  Product({this.id,this.name, this.price, this.description, this.gender ,this.category, this.image,this.path});

  Map<String,dynamic> toMap(){
    return {
      productsName:name,
      productPrice:price,
      productDescription:description,
      productGender:gender,
      productCategory:category,
      productImage:image,
      productPath : path
    };
  }

}