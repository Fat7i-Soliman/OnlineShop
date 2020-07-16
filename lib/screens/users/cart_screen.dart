import 'package:e_commerce/models/cart_items.dart';
import 'package:e_commerce/models/global_productID.dart';
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
                      image: AssetImage('images/0.jpg'),
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
                'Total Price: \$7000',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              )),
              color: Colors.blueGrey[100],
            )),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FlatButton(
                  onPressed: () {},
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
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[300]
        ),
        height: 200,
        child: Center(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 ListTile(
                   onTap: (){
                     GlobalProductId.instance.set(cartItems[index].product);
                     Navigator.pop(context);
                     Navigator.of(context).pushNamed(DetailsScreen.id);
                   },
                   title: Text('View Product',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                 ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    onTap: (){
                      setState(() {
                        cartItems.removeAt(index);
                        Navigator.pop(context);

                      });
                    },
                    title: Text('Delete from cart',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                  ),
                  Divider(color: Colors.grey,),
                  ListTile(
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    title: Text('Cancel',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                  ),
                ],
              ),
        ),
      ),
    ));
  }
}
