import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/cart_items.dart';
import 'package:e_commerce/models/global_productID.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/provider/cart_items.dart';
import 'package:e_commerce/screens/users/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  static String id = 'DetailsScreen';
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  int quantity = 1 ;
  Product product = GlobalProductId.instance.get();
  GlobalKey<ScaffoldState>_globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height ;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart,),onPressed: (){
            Navigator.pushNamed(context, CartScreen.id);
          },)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height*.5,
              child: Image(image: NetworkImage(product.image),fit: BoxFit.fill,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${product.name}',style: TextStyle(fontSize: 24),),
                      SizedBox(height: 10,),
                      Text('\$ ${product.price}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Icon(Icons.favorite,color: Colors.grey[400],)
                ],
              ),
            ),
            SizedBox(height: 10,child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: Divider(thickness: 1,color: Colors.grey[300],),
            ),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 10),
              child: Text('${product.description}',textAlign: TextAlign.start,),
            ),
            SizedBox(height: 10,),

            Row(
              children: <Widget>[
                IconButton(icon:Icon(Icons.indeterminate_check_box,color: Colors.blueGrey,size: 32,),
                onPressed: (){
                  sub();
                },
                ),
                SizedBox(width: 5,),
                Text('$quantity',style: TextStyle(fontSize: 24),),
                SizedBox(width: 5,),
                IconButton(icon:Icon(Icons.add_box,color: Colors.blueGrey,size: 32,),
                onPressed: (){
                  add();
                },
                ),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueGrey)
                    ),
                    child: IconButton(icon: Icon(Icons.add_shopping_cart,color: Colors.blueGrey,), onPressed: (){
                      CartItems items = Provider.of<CartItems>(context,listen: false);
                      bool check = items.checkProduct(product);
                      if(check){
                        _globalKey.currentState.showSnackBar(SnackBar(content: Text('already exist'),duration: Duration(milliseconds: 500)));
                      }else{
                        items.addItem(product, quantity);
                        _globalKey.currentState.showSnackBar(SnackBar(content: Text('Added '),duration: Duration(milliseconds: 500)));
                      }
                    }),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FlatButton(
                          onPressed: (){
                            showAlertDialog(context);
                          },
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text('Buy now'.toUpperCase(),style: TextStyle(fontSize: 18,color: Colors.white),)
                      ),
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  add(){
    setState(() {
      quantity++;
    });

  }
  sub(){
    if(quantity>1){
      setState(() {
        quantity--;
      });
    }
  }

  Future showAlertDialog(BuildContext context) async {
    final location = TextEditingController();
    final phone = TextEditingController();
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('request the order'),
          content: Container(
            height: 250,
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
                SizedBox(height: 50),
                Text(
                  'Total price : \$${totalCost()}',
                ),
              ],
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
                        SnackBar(content: Text('Order completed'),duration: Duration(milliseconds: 500),));
                  }
                },
                child: Text('Confirm')),
          ],
        ));
  }

  requestOrder(String phone, String location) async {
    List<ItemCart> list = List();
    list.add(ItemCart(product: product,quantity: quantity));
    String id;
    await Auth().auth.currentUser().then((value) => id = value.uid);
    Order order =
    Order(uId: id, address: location, phone: phone, cartItems: list,done: false,totalPrice: totalCost().toString());

    Store().addOrder(order);
  }

  int totalCost() {
    return int.parse(product.price) * quantity ;
  }
}
