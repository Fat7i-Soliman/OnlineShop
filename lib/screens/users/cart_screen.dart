import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/cart_items.dart';
import 'package:e_commerce/models/global_productID.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/provider/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'details_screen.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  List<ItemCart> cartItems;

  @override
  Widget build(BuildContext context) {
    cartItems = Provider.of<CartItems>(context).list;

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blueGrey,
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text('Cart is empty...'),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      showSheet(index);
                    },
                    leading: Image(
                      image: NetworkImage(cartItems[index].product.image),
                      fit: BoxFit.fill,
                      height: 70,
                      width: 50,
                    ),
                    title: Text(
                      cartItems[index].product.name,
                      style: TextStyle(fontSize: 22),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total: \$${singleItemTotal(index)}'),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.indeterminate_check_box,
                                color: Colors.blueGrey,
                                size: 28,
                              ),
                              onPressed: () {
                                sub(index);
                              },
                            ),
                            Text(
                              '${cartItems[index].quantity}',
                              style: TextStyle(fontSize: 22),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_box,
                                color: Colors.blueGrey,
                                size: 28,
                              ),
                              onPressed: () {
                                add(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
              height: 50,
              child: Center(
                  child: Text(
                'Total Price: \$${totalCost()}',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              )),
              color: Colors.blueGrey[100],
            )),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FlatButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  child: Text(
                    'Order now'.toUpperCase(),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  color: Colors.blueGrey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  int singleItemTotal(int index) {
    return int.parse(cartItems[index].product.price) *
        cartItems[index].quantity;
  }

  int totalCost() {
    int cost = 0;
    for (var i in cartItems) {
      cost += int.parse(i.product.price) * i.quantity;
    }
    return cost;
  }

  add(int index) {
    setState(() {
      cartItems[index].quantity = cartItems[index].quantity + 1;
    });
  }

  sub(int index) {
    if (cartItems[index].quantity > 1) {
      setState(() {
        cartItems[index].quantity = cartItems[index].quantity - 1;
      });
    }
  }

  showSheet(int index) {
    _globalKey.currentState.showBottomSheet((context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[300]),
            height: 200,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      GlobalProductId.instance.set(cartItems[index].product);
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(DetailsScreen.id);
                    },
                    title: Text(
                      'View Product',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        cartItems.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                    title: Text('Delete from cart',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    title: Text('Cancel',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future showAlertDialog(BuildContext context) async {
    final location = TextEditingController();
    final phone = TextEditingController();
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('request the order'),
          content: SingleChildScrollView(
            child: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter your location',
                        labelText: 'Location',
                        icon: Icon(Icons.add_location)),
                    controller: location,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter your Phone number',
                        labelText: 'Phone',
                        icon: Icon(Icons.phone)),
                    keyboardType: TextInputType.phone,
                    controller: phone,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Total price : \$${totalCost()}',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  if (location.text.isNotEmpty && phone.text.isNotEmpty) {
                    requestOrder(phone.text, location.text);
                    Navigator.pop(context);
                    _globalKey.currentState.showSnackBar(
                        SnackBar(content: Text('Order completed')));
                  }
                },
                child: Text('Confirm')),
          ],
        ));
  }

  requestOrder(String phone, String location) async {
    String id;
    await Auth().auth.currentUser().then((value) => id = value.uid);
    Order order =
        Order(uId: id, address: location, phone: phone, cartItems: cartItems,done: false,totalPrice: totalCost().toString());

    Store().addOrder(order);
  }
}
