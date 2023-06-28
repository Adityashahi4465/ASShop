
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'reviews_list.dart';

class ExpendedReviews extends StatelessWidget {
  final dynamic proList;
  const ExpendedReviews({super.key, this.proList});

  @override
  Widget build(BuildContext context) {
    final allReviewsStream = FirebaseFirestore.instance
        .collection('products')
        .doc(proList['proId'])
        .collection('reviews')
        .snapshots();

    final limitedReviewsStream = FirebaseFirestore.instance
        .collection('products')
        .doc(proList['proId'])
        .collection('reviews')
        .limit(3)
        .snapshots();
    return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Reviews',
          style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
      ),
      collapsed: ReviewsList(reviewsStream: limitedReviewsStream),
      expanded: ReviewsList(reviewsStream: allReviewsStream),
    );
  }
}
