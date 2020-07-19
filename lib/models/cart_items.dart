import 'package:e_commerce/models/product.dart';

import '../constants.dart';

class ItemCart{

  Product product ;
  int quantity ;
  ItemCart({this.product,this.quantity});

  Map<String,dynamic> toMap(){
    return {
      orderQuantity : quantity ,
      productsName:product.name,
      productPrice:product.price,
      productDescription:product.description,
      productGender:product.gender,
      productCategory:product.category,
      productImage:product.image
    };
  }
}