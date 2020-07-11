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
                image: DecorationImage(image: AssetImage('images/cover.jpg'),fit: BoxFit.fill),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
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
                      Text('Categories',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                      Text('All',style: TextStyle(color: Colors.black),)

                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        createCategory('T-shirt','images/cat1.jpg'),
                        createCategory('shirts','images/cat1.jpg'),
                        createCategory('sweaters','images/cat1.jpg'),
                        createCategory('jackets','images/cat1.jpg'),
                        createCategory('Shorts & Pants','images/cat1.jpg'),
                        createCategory('shoes','images/cat1.jpg'),

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
            image: DecorationImage(image: AssetImage(image),fit: BoxFit.fill),
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
