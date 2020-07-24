import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/order.dart';
import 'package:flutter/material.dart';

class AllOrders extends StatefulWidget {
  static String id = 'AllOrders';
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {

  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.blueGrey,
      ),
      body: getAllOrders(),
    );
  }

  getAllOrders() {
    return StreamBuilder<QuerySnapshot>(

        stream: _store.getAllOrders(),
        builder: (context, snapshot) {
          List<Order> orders = List();

          if (snapshot.data != null) {

            for (var doc in snapshot.data.documents) {
              var data = doc.data;
              print('data : $doc');

              orders.add( _store.toOrderOb(data, doc.reference.path));
            }

            if (orders.length != 0) {
              return ListView.builder(

                  itemCount: orders.length,

                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          //TODO view order details

                        },
                        leading: Image.asset('images/icons/shop_app.png'),
                        title: Text('Order Cash : ${orders[index].totalPrice}'),
                        subtitle: Text(
                            'open to view details >>'),
                      ),
                    );
                  }
              );
            } else {
              return Center(child: Text('No Orders Found !!'),);
            }
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        });
  }
}
