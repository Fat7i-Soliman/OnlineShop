import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserPage extends StatefulWidget {
  static String id = 'UserPage';
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                             IconButton(icon: Icon(Icons.shopping_cart),color: Colors.white, onPressed: (){})
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
                        createCategory('T-shirt','images/t-shirt.jpg'),
                        createCategory('Shirts','images/shirt1.jpg'),
                        createCategory('Sweaters','images/sweater.png'),
                        createCategory('Jackets','images/jacket.png'),
                        createCategory('Shorts & Pants','images/pants.png'),
                        createCategory('Blazers','images/blazer.png'),
                        createCategory('Sunglasses','images/glasses.webp'),
                        createCategory('Shoes','images/shoe.jpg'),

                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10, child: Padding(
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
                        createCategory('Blouses','images/blouse.jpg'),
                        createCategory('Dresses','images/dress.jpeg'),
                        createCategory('Skirts & Pants','images/women-pants.webp'),
                        createCategory('Blazers','images/women-plazer.webp'),
                        createCategory('shoes','images/women-shoe.webp'),
                        createCategory('Bags & Accessories','images/bags.jpeg'),
                        createCategory('Beauty','images/bag.jpeg'),



                      ],
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

  Widget createCategory(String type,String image){
   return AspectRatio(
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
    );
  }

}
