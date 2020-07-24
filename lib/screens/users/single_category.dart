import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/global_productID.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/users/details_screen.dart';
import 'package:flutter/material.dart';

class SingleCategory extends StatefulWidget {
  static String id='SingleCategory';
  @override
  _SingleCategoryState createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  GlobalCategory category = GlobalCategory.instance ;
  Store _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(category.getTitle()),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(child: getData(category.getCat())),
    );
  }

  Widget getData(category){
    return StreamBuilder<QuerySnapshot>(

        stream: _store.getProducts(category),
        builder: (context,snapshot){
          List<Product> products = List();
          print("data ${snapshot.data}");

          if(snapshot.data !=null) {
            print("data ${snapshot.data}");

            for (var doc in snapshot.data.documents) {
              var data = doc.data;
              products.add(_store.toObject(data, doc.documentID));
            }
            if (products.length != 0) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .8,
                  ),
                  itemCount: products.length,

                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        viewProduct(products[index]);
                      },
                      child: Card(
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(child: Image(
                              image: NetworkImage(products[index].image),
                              fit: BoxFit.cover,)),
                            Positioned(
                                bottom: 0,
                                child: Opacity(
                                  opacity: .7,
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text('${products[index].name}',
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold),),
                                          Text('\$ ${products[index].price}',)

                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  }
              );
            } else {
              return Center(child: Text('No Products Found !!'),);
            }
          }else{

            return Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

  viewProduct(Product ob){
    GlobalProductId.instance.set(ob);
    Navigator.of(context).pushNamed(DetailsScreen.id);
    print('product id : ${ob.id}');
  }

}
