import 'package:as_shop/customer_screens/add_address.dart';
import 'package:as_shop/widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data_models/address_data_model.dart';
import '../widgets/appbar_widgets.dart';

class AddressBook extends StatelessWidget {
  const AddressBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _addressStream =
        FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('address')
            .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(title: 'Address Book'),
        centerTitle: true,
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: YellowButton(
              label: 'Add New Address',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAddress()));
              },
              width: 0.8,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _addressStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Failed to load addresses',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (snapshot.data?.docs.isEmpty ?? true) {
              return Center(
                child: Text(
                  'You haven\'t added any addresses yet!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.acme(
                    fontSize: 26,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var addressData = snapshot.data!.docs[index].data();
                  var address = Address.fromMap(addressData);
                  return AddressCard(
                    address: address,
                    onMakeDefault: () async {
                      try {
                        // Mark the selected address as default in Firestore
                        await FirebaseFirestore.instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('address')
                            .doc(address.id)
                            .update({'isDefault': true});

                        // Clear the 'isDefault' field for all other addresses
                        await FirebaseFirestore.instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('address')
                            .where('id', isNotEqualTo: address.id)
                            .get()
                            .then((snapshot) {
                          for (var doc in snapshot.docs) {
                            doc.reference.update({'isDefault': false});
                          }
                        });

                        // Show success message or perform any other actions
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Address set as default'),
                          ),
                        );
                      } catch (error) {
                        // Handle errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to set address as default'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final Address address;
  final Function() onMakeDefault; // Callback function

  const AddressCard(
      {Key? key, required this.address, required this.onMakeDefault})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpandablePanel(
        header: ListTile(
          title: Text.rich(
            TextSpan(
              text: '${address.firstName} ${address.lastName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: address.isDefault ? '  (default)' : '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                )
              ],
            ),
          ),
          subtitle: Text(
            '${address.houseNumber}, ${address.city}, ${address.state}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
        ),
        collapsed: Container(),
        expanded: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Name', '${address.firstName} ${address.lastName}'),
              _buildField('Phone', address.phone),
              _buildField('House Number', address.houseNumber),
              _buildField('Street', address.street),
              _buildField('City', address.city),
              _buildField('State', address.state),
              _buildField('Country', address.country),
              _buildField('Postal Code', address.postalCode),
              address.isDefault
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: () {
                        onMakeDefault();
                      },
                      child: const Text(
                        'Make Default',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _getIconForLabel(label),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Icon _getIconForLabel(String label) {
    IconData iconData;
    switch (label.toLowerCase()) {
      case 'name':
        iconData = Icons.person;
        break;
      case 'phone':
        iconData = Icons.phone;
        break;
      case 'house number':
        iconData = Icons.home;
        break;
      case 'street':
        iconData = Icons.location_on;
        break;
      case 'city':
        iconData = Icons.location_city;
        break;
      case 'state':
        iconData = Icons.location_on;
        break;
      case 'country':
        iconData = Icons.location_on;
        break;
      case 'postal code':
        iconData = Icons.location_on;
        break;
      default:
        iconData = Icons.info;
        break;
    }
    return Icon(
      iconData,
      size: 16,
      color: Colors.blueGrey,
    );
  }
}
