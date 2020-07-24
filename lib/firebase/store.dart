import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/cart_items.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
class Store{
  final store = Firestore.instance ;

  addProduct(Product product) async {
   await store.collection(productsCollection).document('allCategories').collection(product.category).add(product.toMap());
  }

  Stream<QuerySnapshot>getProducts(category)  {
    return  store.collection(productsCollection).document('allCategories').collection(category)
        .snapshots();
  }

  deleteProduct(String id,Product product) async{
    await store.collection(productsCollection).document('allCategories').collection(product.category).document(id).delete().whenComplete(() {
       FirebaseStorage.instance
          .ref()
          .child('productImages/${product.path}').delete();
    });
  }

  editProduct(Product product,id) {
    store.collection(productsCollection).document('allCategories').collection(product.category).document(id).updateData(product.toMap()).catchError((error){
      print('edit error: ${error.message}');

    });
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


  Stream<QuerySnapshot> getMyOrders(String uid){
    return store.collection(orders).document(users).collection(uid).snapshots();
  }

  Stream<QuerySnapshot> getAllOrders(){
    return store.collection(orders).document(admins).collection(allOrders).snapshots();
  }

  // convert to objects


  Product toObject(Map<String,dynamic> map,String productId){
    Product ob  = Product(
      id: productId,
      name: map[productsName],
      description : map[productDescription],
      gender: map[productGender],
      price : map[productPrice],
      category : map[productCategory],
      image : map[productImage],
      path: map[productPath]
    );
    return ob ;

  }
  Order toOrderOb(Map<String, dynamic> map,id){
    Order order = Order(
        uId: map[userId],
        phone: map[userPhone],
        address: map[userAddress],
        totalPrice: map[totalCash],
        done: map[delivered]
      //  cartItems: await getProductOfOrder(id)
    );

    return order ;
  }

  Future<List<ItemCart>>getProductOfOrder (path)async{
    List<ItemCart> result = List();

    try {
     await store.document(path).collection(myOrders).getDocuments().then((value) {
        if (value.documents.isNotEmpty) {
          for (var item in value.documents) {
            result.add(toCartItemOb(item.data));
          }
        }
      });
      print('results : ${result.length}');

      return result;
    }catch(ex){
      return result ;
    }

  }

  ItemCart toCartItemOb(Map<String, dynamic> map){
    ItemCart ob = ItemCart(
        quantity: map[orderQuantity],
        product: Product(
            name: map[productsName],
            category: map[productCategory],
            gender: map[productGender],
            description: map[productDescription],
            price: map[productPrice],
            image: map[productImage]
        )
    );
    print('object : ${ob.product.category} , ${ob.product.name} ,${ob.quantity}');

    return ob ;
  }

}