import 'package:e_commerce/models/global_productID.dart';
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
              child: Image(image: AssetImage('images/0.jpg'),fit: BoxFit.fitHeight,),
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
                        _globalKey.currentState.showSnackBar(SnackBar(content: Text('already exist')));
                      }else{
                        items.addItem(product, quantity);
                        _globalKey.currentState.showSnackBar(SnackBar(content: Text('Added ')));
                      }
                    }),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FlatButton(
                          onPressed: (){
                            //todo order the product
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
}
