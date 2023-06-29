import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:as_shop/widgets/snackbar.dart';
import 'package:as_shop/widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../data_models/address_data_model.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _houseNumberController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (countryValue.isNotEmpty &&
          stateValue.isNotEmpty &&
          cityValue.isNotEmpty) {
        _formKey.currentState!.save();
        // Create an instance of the Address class
        var addressId = const Uuid().v4();

        Address address = Address(
          country: countryValue,
          state: stateValue,
          city: cityValue,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          houseNumber: _houseNumberController.text.trim(),
          street: _streetController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          isDefault: false,
          id: addressId,
        );

        try {
          try {
            // Get the customers collection reference

            CollectionReference customersCollection = FirebaseFirestore.instance
                .collection('customers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('address');
            await customersCollection.doc(addressId).set(address.toMap());

            // Show success message or navigate to another screen
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'Address added successfully!');
            await Future.delayed(const Duration(milliseconds: 500))
                .then((_) => Navigator.pop(context));
          } catch (e) {
            // Show error message
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'Failed to add address. Please try again.');
          }
        } catch (e) {
          // Show error message
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Failed to add address. Please try again.');
        }
      } else {
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'Please pick the location!');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
          title: const AppBarTitle(
            title: 'Add Address',
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 40, 12, 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                                decoration: textFormDecoration.copyWith(
                                  labelText: 'First Name',
                                  hintText: 'Enter your First Name',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                                decoration: textFormDecoration.copyWith(
                                  labelText: 'Last Name',
                                  hintText: 'Enter your Last Name',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Phone Number',
                            hintText: 'Enter your phone number',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _houseNumberController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your house number';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'House Number',
                            hintText: 'Enter your house number',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _streetController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your street';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Street',
                            hintText: 'Enter your street',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _postalCodeController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your postal code';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Postal Code',
                            hintText: 'Enter your postal code',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 60),
                  child: CSCPicker(
                    dropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    disabledDropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    defaultCountry: CscCountry.India,
                    selectedItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    dropdownHeadingStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    dropdownItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    dropdownDialogRadius: 10.0,
                    searchBarRadius: 10.0,
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value ?? '';
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value ?? '';
                      });
                    },
                  ),
                ),
                Center(
                  child: YellowButton(
                    label: 'Add New Address',
                    onPressed: _submitForm,
                    width: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: Colors.purple, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
  ),
);
