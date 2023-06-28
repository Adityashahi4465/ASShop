import 'package:as_shop/data_models/review_model.dart';
import 'package:as_shop/widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  var feedback = '';

  var rating = 0.0;

  Future<void> addAppReview(Review review) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.order['proid'])
          .collection('reviews')
          .doc(uid)
          .set(review.toMap())
          .whenComplete(() async {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference docRef = FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.order['orderid']);
          transaction.update(docRef, {
            'orderreview': true,
          });
        });
      });
      await Future.delayed(const Duration(microseconds: 100))
          .whenComplete(() => Navigator.pop(context));
    } catch (e) {
      print('reviewing failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.yellow,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.order['orderimage']),
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order['ordername'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$ ${widget.order['orderprice'].toStringAsFixed(2)}',
                            ),
                            Text(
                              'x ${widget.order['orderqty'].toString()}',
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('See More..'),
              Text(widget.order['deliverystatus']),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['deliverystatus'] == 'delivered'
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${widget.order['custname']}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Phone No: ${widget.order['phone']}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Email Address: ${widget.order['email']}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Address: ${widget.order['address']}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Payment Status: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${widget.order['paymentstatus']}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Delivery status: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${widget.order['deliverystatus']}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    widget.order['deliverystatus'] == 'shipping'
                        ? Text(
                            'Estimated Delivery Date: ${DateFormat('dd-MMMM-yyyy').format(widget.order['deliverydate'].toDate())}',
                            style: const TextStyle(fontSize: 15),
                          )
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: const Center(
                                        child: Text(
                                          "Review",
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      children: [
                                        Center(
                                          child: RatingBar.builder(
                                            initialRating: rating,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (value) {
                                              rating = value;
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Center(
                                          child: TextFormField(
                                            initialValue: feedback,
                                            decoration: const InputDecoration(
                                              hintText: "Feedback of Product",
                                              labelText: "Feedback (optional)",
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            onChanged: (value) {
                                              feedback = value;
                                            },
                                            maxLines: null,
                                            maxLength: 150,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: YellowButton(
                                            label: 'Submit',
                                            onPressed: () async {
                                              await addAppReview(
                                                Review(
                                                  name:
                                                      widget.order['custname'],
                                                  email: widget.order['email'],
                                                  rating: rating,
                                                  feedback: feedback,
                                                  profileimage: widget
                                                      .order['profileimage'],
                                                ),
                                              );
                                              Navigator.pop(context);
                                            },
                                            width: 40,
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Text('Write Review'),
                          )
                        : const Text(''),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == true
                        ? const Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                              Text(
                                'Review Added',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
