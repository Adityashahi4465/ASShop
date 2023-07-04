import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';

class ShoesGalleryScreen extends StatefulWidget {
  final bool fromOnBoarding;
  const ShoesGalleryScreen({
    Key? key,
    this.fromOnBoarding = false,
  }) : super(key: key);

  @override
  State<ShoesGalleryScreen> createState() => _ShoesGalleryScreenState();
}

class _ShoesGalleryScreenState extends State<ShoesGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincategory', isEqualTo: 'shoes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromOnBoarding
          ? AppBar(
              title: const AppBarTitle(title: 'Shoes'),
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/customer_home'),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  )),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
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
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            ),
          );

          /* ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                leading: Image(
                  image: NetworkImage(data['proimages'][0]),
                ),
                title: Text(data['productname']),
                subtitle: Text(data['price'].toString()),
              );
            }).toList(),
          );
           */
        },
      ),
    );
  }
}
