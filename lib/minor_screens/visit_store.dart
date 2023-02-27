import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';

class VisitStore extends StatefulWidget {
  final String supplierId; // supplierId
  const VisitStore({required this.supplierId, super.key});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.supplierId)
        .snapshots();
    CollectionReference supplier =
        FirebaseFirestore.instance.collection('suppliers');

    return FutureBuilder<DocumentSnapshot>(
      future: supplier.doc(widget.supplierId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: Image.asset(
                'images/inapp/coverimage.jpg',
                fit: BoxFit.cover,
              ),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Colors.yellow,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['storename'],
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.yellow),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            border: Border.all(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                following = !following;
                              });
                            },
                            child: following == true
                                ? const Text('following')
                                : const Text('FOLLOW'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('This category \n\n has not items yet !',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.acme(
                            fontSize: 26,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          )),
                    );
                  }
                  return SingleChildScrollView(
                    child: StaggeredGridView.countBuilder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        return ProductModel(
                          products: snapshot.data!.docs[index],
                        );
                      },
                      staggeredTileBuilder: (context) =>
                          const StaggeredTile.fit(1),
                    ),
                  );
                },
              ),
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
