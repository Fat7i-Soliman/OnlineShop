import 'package:e_commerce/constants.dart';
import 'package:e_commerce/firebase/auth.dart';
import 'package:e_commerce/models/global_productID.dart';
import 'package:e_commerce/screens/users/cart_screen.dart';
import 'package:e_commerce/screens/users/single_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserPage extends StatefulWidget {
  static String id = 'UserPage';
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  GlobalKey<ScaffoldState> _key  = GlobalKey<ScaffoldState>();
  Auth _auth = Auth();
  Widget makeMenu(context) {
    var size = MediaQuery.of(context).size ;

    return Container(
      width: size.width*.7,

      child: Column(
        children: <Widget>[
          Container(
            height: size.height*.25,
            color: Colors.blueGrey,
          ),
          ListTile(
            leading: Icon(Icons.home,color: Colors.blueGrey,),
            title: Text('Home'),
            onTap: ()=> Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart,color: Colors.blueGrey,),
            title: Text('Cart'),
            onTap: ()=> Navigator.pushNamed(context, CartScreen.id)
          ),
          ListTile(
            leading: Icon(Icons.card_travel,color: Colors.blueGrey,),
            title: Text('My orders'),
          ),
          SizedBox(height: 5,child: Divider(thickness: 1,color: Colors.grey,),),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.blueGrey,),
            title: Text('Log out'),
            onTap: ()  {
                showAlertDialog(context) ;
            }
          ),
        ],
      ),
    );
  }




  Future showAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Log Out !'),
          content: Text('Are you sure you want to exit ?'),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(onPressed: (){
              Navigator.pop(context);
              _auth.signOut() ;

            }, child: Text('Log out')),

          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 450,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('images/shopping-market.jpg'),fit: BoxFit.fill),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.1),
                  ],
                  begin: Alignment.bottomRight)
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.menu),color: Colors.white, onPressed: (){
                              _key.currentState.openDrawer();
                            }),
                             IconButton(icon: Icon(Icons.shopping_cart),color: Colors.white, onPressed: (){
                               Navigator.pushNamed(context, CartScreen.id);
                             })
                             ],
                        ),
                        Text('Our New Products',style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold),)

                    ]
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Men Categories',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                      Text('All ',style: TextStyle(color: Colors.black),)

                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 170,
                    child: ListView(

                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        createCategory('T-shirt','images/t-shirt.jpg',t_shirt),
                        createCategory('Shirts','images/shirt1.jpg',shirt),
                        createCategory('Sweaters','images/sweater.png',sweaters),
                        createCategory('Jackets','images/jacket.png',jackets),
                        createCategory('Shorts & Pants','images/pants.png',Pants),
                        createCategory('Blazers','images/blazer.png',blazers),
                        createCategory('Sunglasses','images/glasses.webp',sunGlasses),
                        createCategory('Shoes','images/shoe.jpg',shoes),

                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(thickness: 3,),
            ),),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Women Categories',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                      Text('All ',style: TextStyle(color: Colors.black),)

                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        createCategory('Blouses','images/blouse.jpg',blousesWomen),
                        createCategory('Dresses','images/dress.jpeg',dressesWomen),
                        createCategory('Skirts & Pants','images/women-pants.webp',PantsWomen),
                        createCategory('Blazers','images/women-plazer.webp',blazersWomen),
                        createCategory('shoes','images/women-shoe.webp',shoesWomen),
                        createCategory('Bags & Accessories','images/bags.jpeg',bagsWomen),
                        createCategory('Beauty','images/bag.jpeg',beautyWomen),



                      ],
                    ),
                  ),
                  SizedBox(height: 10,),

                ],
              ),
            )


          ],
        ),
      ),
      drawer: Drawer(
        child: makeMenu(context),
      ),

    );

  }

  Widget createCategory(String type,String image,String category){
   return GestureDetector(
     onTap:() {
       print(type);
       openCategory(category,type);
     },
     child: AspectRatio(
        aspectRatio: 2/2.4,
        child: Container(
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(image),fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.0),
                ],
                    begin: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20)

            ),
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(child: Text(type,style: TextStyle(color: Colors.white,fontSize: 16)),alignment: Alignment.bottomLeft,),
            ) ,
          ),

        ),
      ),
   );
  }

  openCategory(String type,title) {
    print(type);
    GlobalCategory.instance.setCat(type) ;
    GlobalCategory.instance.setTitle(title) ;

    Navigator.pushNamed(context, SingleCategory.id);
  }

}
