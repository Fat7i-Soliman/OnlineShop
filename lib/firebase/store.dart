import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
class Store{
  final store = Firestore.instance ;

  addProduct(Product product) async {
   await store.collection(productsCollection).add(product.toMap()).whenComplete(() => print('added')).catchError((error){
      print(error.message);
    });
  }

  Stream<QuerySnapshot>getProducts() {
    return store.collection(productsCollection)
        .snapshots();
  }


  Product toObject(Map<String,dynamic> map){
    Product ob  = Product(
      name: map[productsName],
      description : map[productDescription],
      price : map[productPrice],
      category : map[productCategory],
      image : map[productImage],
    );
    return ob ;

  }
}