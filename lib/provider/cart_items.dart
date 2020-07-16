import 'package:e_commerce/models/cart_items.dart';
import 'package:e_commerce/models/product.dart';
import 'package:flutter/material.dart';

class CartItems extends ChangeNotifier{
  List<ItemCart> list = List();

  addItem(product,quantity){
    list.add(ItemCart(product: product,quantity: quantity));
    notifyListeners();
  }

  bool checkProduct(Product product){
    bool check = false ;
    for(var pro in list){
      if(pro.product == product){
        check = true ;
        break ;
      }
    }
    return check;
  }
}