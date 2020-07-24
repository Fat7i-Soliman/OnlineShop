import 'package:e_commerce/models/cart_items.dart';
import 'package:e_commerce/constants.dart';

class Order {
  String uId ;
  List<ItemCart> cartItems;
  String address;
  String totalPrice ;
  bool done ;
  String phone;

  Order({this.uId,this.address, this.phone, this.cartItems,this.totalPrice,this.done});

  Map<String, dynamic> toOrderMap() {
    return {
      userId : uId,
      userPhone: phone,
      userAddress: address,
      totalCash: totalPrice,
      delivered : done
    };
  }

  List<Map<String, dynamic>> products(){
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>();

    for (var item in cartItems){
      list.add(item.toMap());
    }
    return list;
  }


}