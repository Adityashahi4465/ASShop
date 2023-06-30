import 'package:as_shop/customer_screens/add_address.dart';
import 'package:as_shop/customer_screens/addresses_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data_models/address_data_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/yellow_button.dart';
import 'payment_screen.dart';
import 'widgets/address_block.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Some error occurred');
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

        final addressData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final address = Address.fromMap(addressData);

        return Material(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  'Place Order',
                  style: GoogleFonts.acme(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                child: Column(
                  children: [
                    snapshot.data!.docs.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressBook(),
                                ),
                              );
                            },
                            child: AddressBlock(address: address),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddAddress(),
                                ),
                              );
                            },
                            child: Text(
                              'Add a new address',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.acme(
                                fontSize: 24,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Consumer<Cart>(
                          builder: (context, cart, child) {
                            return ListView.builder(
                                itemCount: cart.getItems.length,
                                itemBuilder: ((context, index) {
                                  final order = cart.getItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15)),
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                  order.imagesUrl.first),
                                            ),
                                          ),
                                          Flexible(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      order.price
                                                          .toStringAsFixed(2),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .grey.shade600,
                                                      ),
                                                    ),
                                                    Text(
                                                      'x ${order.qty.toString()}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .grey.shade600,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                }));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomSheet: Padding(
                padding: const EdgeInsets.all(8.0),
                child: YellowButton(
                  label: 'Confirm ${totalPrice.toStringAsFixed(2)} USD',
                  width: 1,
                  onPressed: snapshot.data!.docs.isEmpty
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddAddress(),
                            ),
                          )
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                name:
                                    '${address.firstName} ${address.lastName}',
                                phone: address.phone,
                                address:
                                    "${address.houseNumber}, ${address.state}, ${address.city} - ${address.postalCode}, ${address.country}",
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
