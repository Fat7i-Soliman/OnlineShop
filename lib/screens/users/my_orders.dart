import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrdersScreen extends StatefulWidget {
  static String id = 'MyOrdersScreen';
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {

  Store _store = Store();
  String uid;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.blueGrey,
      ),
      body: getOrders(),
    );
  }

  Widget getOrders() {
    final user = Provider.of<User>(context);

    print('uder id : ${user.id}');
    return StreamBuilder<QuerySnapshot>(

        stream: _store.getMyOrders(user.id),
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
                        title: Text('Order Request ${index + 1}'),
                        subtitle: Text(
                            'open to view details >>'),
                        trailing: orders[index].done ? Icon(Icons.done): Icon(Icons.schedule) ,
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

  loadOrder(snapshot) {

  }

}