import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/customer_order_model.dart';
import '../widgets/appbar_widgets.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(
          title: 'My Orders',
        ),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('orderdate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
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
                child: Text('You don\'t have any active orders at the moment.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.acme(
                      fontSize: 26,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    )),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CustomerOrderModel(
                  order: snapshot.data!.docs[index],
                );
              },
            );
          }),
    );
  }
}
