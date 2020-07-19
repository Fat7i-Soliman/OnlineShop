import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/product.dart';
class Store{
  final store = Firestore.instance ;

  addProduct(Product product) async {
   await store.collection(productsCollection).document('allCategories').collection(product.category).add(product.toMap());
  }

  Stream<QuerySnapshot>getProducts(category)  {
    return  store.collection(productsCollection).document('allCategories').collection(category)
        .snapshots();
  }

  deleteProduct(String id){
    store.collection(productsCollection).document(id).delete();
  }

  editProduct(product,id) {
    store.collection(productsCollection).document(id).updateData(product.toMap()).catchError((error){
      print('edit error: ${error.message}');

    });
  }
  Product toObject(Map<String,dynamic> map,String productId){
    Product ob  = Product(
      id: productId,
      name: map[productsName],
      description : map[productDescription],
      gender: map[productGender],
      price : map[productPrice],
      category : map[productCategory],
      image : map[productImage],
    );
    return ob ;

  }

  addOrder(Order item)async{
    List list = item.products();

    await store.collection(orders).document(admins).collection(allOrders).add(item.toOrderMap()).then((value) {
      for(var i in list){
        value.collection(myOrders).add(i);
      }
    });

    await store.collection(orders).document(users).collection(item.uId).add(item.toOrderMap()).then((value) {
      for(var i in list){
        value.collection(myOrders).add(i);
      }
    });
  }
}