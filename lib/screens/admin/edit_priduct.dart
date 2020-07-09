import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/product.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  static String id = 'EditProduct';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(

        stream: _store.getProducts(),
          builder: (context,snapshot){
            List<Product> products = List();

            for(var doc in snapshot.data.documents){

              var data = doc.data ;
              products.add(_store.toObject(data));
            }
            if(products!=null){
              return ListView.builder(
                itemCount: products.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text('${products[index].name}'),
                    );
                  }
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}
