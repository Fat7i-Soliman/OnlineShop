import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/firebase/store.dart';
import 'package:e_commerce/models/global_productID.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/admin/edit_page.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  static String id = 'EditProduct';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  Store _store = Store();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 15,
      child: Scaffold(
        appBar: AppBar(
          title: Text('all categories'),
          backgroundColor: Colors.blueGrey,
          bottom: TabBar(tabs: [
            Tab(text: t_shirt,),
            Tab(text: shirt,),
            Tab(text: sweaters,),
            Tab(text: jackets,),
            Tab(text: blazers,),
            Tab(text: Pants,),
            Tab(text: shoes,),
            Tab(text: sunGlasses,),
            Tab(text: dressesWomen,),
            Tab(text: blousesWomen,),
            Tab(text: beautyWomen,),
            Tab(text: PantsWomen,),
            Tab(text: blazersWomen,),
            Tab(text: shoesWomen,),
            Tab(text: bagsWomen,),
          ],isScrollable: true,),
        ),
        body: TabBarView(children: [
          getData(t_shirt),
          getData(shirt),
          getData(sweaters),
          getData(jackets),
          getData(blazers),
          getData(Pants),
          getData(shoes),
          getData(sunGlasses),
          getData(dressesWomen),
          getData(blousesWomen),
          getData(beautyWomen),
          getData(PantsWomen),
          getData(blazersWomen),
          getData(shoesWomen),
          getData(bagsWomen),

        ]),
      ),
    );
  }


  Widget getData(category){
    return StreamBuilder<QuerySnapshot>(

        stream: _store.getProducts(category),
        builder: (context,snapshot){
          List<Product> products = List();
          if(snapshot.data !=null) {
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
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          editProduct(products[index]);
                        },
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
  editProduct(Product ob){
    GlobalProductId.instance.set(ob);
    Navigator.of(context).pushNamed(EditPage.id);
    print('product id : ${ob.id}');
  }
}
