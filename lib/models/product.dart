import 'package:e_commerce/constants.dart';

class Product{

  String id ,name,price, description,category,image;

  Product({this.id,this.name, this.price, this.description, this.category, this.image});

  Map<String,dynamic> toMap(){
    return {
      productsName:name,
      productPrice:price,
      productDescription:description,
      productCategory:category,
      productImage:image
    };
  }

}