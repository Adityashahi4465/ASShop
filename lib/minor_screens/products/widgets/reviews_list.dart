import 'package:as_shop/models/reviews_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewsList extends StatelessWidget {
  final Stream<QuerySnapshot> reviewsStream;
  const ReviewsList({super.key, required this.reviewsStream});
  @override
  Widget build(BuildContext context) {
   
    return StreamBuilder<QuerySnapshot>(
      stream: reviewsStream,
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
            child: Text('This Item \n\n has no reviews yet !',
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
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index];

            return ReviewModel(
              feedback: data['feedback'].toString(),
              rating: data['rating'].toString(),
              proImage: data['profileimage'].toString(),
              name: data['name'].toString(),
              email: data['email'].toString(),
            );
          },
        );
      },
    );
  }
}
