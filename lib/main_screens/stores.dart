import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/appbar_widgets.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Stores'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('suppliers').snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 25,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: Image.asset('images/inapp/store.jpg'),
                          ),
                          Positioned(
                            bottom: 28,
                            left: 10,
                            child: SizedBox(
                              height: 48,
                              width: 100,
                              child: Image.network(
                                snapshot.data!.docs[index]['storelogo'],
                                fit:  BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        snapshot.data!.docs[index]['storename'],
                        style: GoogleFonts.akayaTelivigala(
                          fontSize: 26,
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(
              child: Text('No Stores Available at this moment'),
            );
          },
        ),
      ),
    );
  }
}
