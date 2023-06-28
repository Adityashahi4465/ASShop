// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

import '../../utilities/categ_list.dart';
import '../../widgets/pink_button.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/yellow_button.dart';

class EditProduct extends StatefulWidget {
  final dynamic items;
  const EditProduct({Key? key, required this.items}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String productname;
  late String prodescription;
  late String proId;
  int? discount = 0;
  String maincategoryValue = 'select category';
  String subcategoryValue = 'subcategory';
  List<String> subcategoryList = [];
  bool processing = false;

  final ImagePicker _picker = ImagePicker();

  List<XFile>? imagesFileList = [];
  List<dynamic> imagesUrlList = [];
  dynamic _pickedImageError;

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesFileList = pickedImages!;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList![index].path));
          });
    } else {
      return const Center(
        child: Text('you have not \n \n picked images yet !',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      );
    }
  }

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.items['proimages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index].toString());
        });
  }

  void selectedMainCategory(String? value) {
    if (value == 'select category') {
      subcategoryList = [];
    } else if (value == 'men') {
      subcategoryList = men;
    } else if (value == 'women') {
      subcategoryList = women;
    } else if (value == 'electronics') {
      subcategoryList = electronics;
    } else if (value == 'accessories') {
      subcategoryList = accessories;
    } else if (value == 'shoes') {
      subcategoryList = shoes;
    } else if (value == 'home & garden') {
      subcategoryList = homeandgarden;
    } else if (value == 'beauty') {
      subcategoryList = beauty;
    } else if (value == 'kids') {
      subcategoryList = kids;
    } else if (value == 'bags') {
      subcategoryList = bags;
    }
    print(value);
    setState(() {
      maincategoryValue = value!;
      subcategoryValue = 'subcategory';
    });
  }

  Future uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imagesFileList!.isNotEmpty) {
        try {
          for (var image in imagesFileList!) {
            firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref('products/${path.basename(image.path)}');

            await ref.putFile(File(image.path)).whenComplete(() async {
              await ref.getDownloadURL().then((value) {
                imagesUrlList.add(value);
              });
            });
          }
        } catch (e) {
          print(e);
        }
      } else {
        imagesUrlList = widget.items['proimages'];
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['proId']);
      Map<String, dynamic> updateData = {
        'price': price,
        'instock': quantity,
        'productname': productname,
        'prodescription': prodescription,
        'proimages': imagesUrlList,
        'discount': discount,
      };

      if (maincategoryValue != 'select category') {
        updateData['maincategory'] = maincategoryValue;
      }
      if (subcategoryValue != 'subcategory') {
        updateData['subcategory'] = subcategoryValue;
      }

      transaction.update(documentReference, updateData);
    });
  }

  saveChanges() async {
    setState(() {
      processing = true;
    });
    await uploadImages().whenComplete(() => editProductData()).whenComplete(() {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: false,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(children: [
                        Container(
                            color: Colors.blueGrey.shade100,
                            height: size.width * 0.5,
                            width: size.width * 0.5,
                            child: previewCurrentImages()),
                        SizedBox(
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    ' main category',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.all(6),
                                    constraints: BoxConstraints(
                                        minWidth: size.width * 0.3),
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child:
                                            Text(widget.items['maincategory'])),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    ' subcategory',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.all(6),
                                    constraints: BoxConstraints(
                                        minWidth: size.width * 0.3),
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child:
                                            Text(widget.items['subcategory'])),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                      ExpandablePanel(
                          theme: const ExpandableThemeData(hasIcon: false),
                          header: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.all(6),
                              child: const Center(
                                child: Text(
                                  'Change Images & Categories',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          collapsed: const SizedBox(),
                          expanded: changeImages(size)),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                              initialValue:
                                  widget.items['price'].toStringAsFixed(2),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter price';
                                } else if (value.isValidPrice() != true) {
                                  return 'invalid price';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                price = double.parse(value!);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'price',
                                hintText: 'price .. \$',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: TextFormField(
                              initialValue: widget.items['discount'].toString(),
                              maxLength: 2,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                } else if (value.isValidDiscount() != true) {
                                  return 'invalid discount';
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                discount = int.parse(value!);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'discount',
                                hintText: 'discount .. %',
                              )),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                          initialValue: widget.items['instock'].toString(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter Quantity';
                            } else if (value.isValidQuantity() != true) {
                              return 'not valid quantity';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Quantity',
                            hintText: 'Add Quantity',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['productname'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            productname = value!;
                          },
                          maxLength: 100,
                          maxLines: 3,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'product name',
                            hintText: 'Enter product name',
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['prodescription'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            prodescription = value!;
                          },
                          maxLength: 800,
                          maxLines: 5,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'product description',
                            hintText: 'Enter product description',
                          )),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          YellowButton(
                              label: 'Cancel',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              width: 0.25),
                          processing
                              ? Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const CircularProgressIndicator(
                                    color: Colors.black,
                                  ))
                              : YellowButton(
                                  label: 'Save Changes',
                                  onPressed: () {
                                    saveChanges();
                                  },
                                  width: 0.5)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PinkButton(
                            label: 'Delete Item',
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(widget.items['proid']);
                                transaction.delete(documentReference);
                              }).whenComplete(() => Navigator.pop(context));
                            },
                            width: 0.7),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget changeImages(Size size) {
    return Column(
      children: [
        Row(children: [
          Container(
            color: Colors.blueGrey.shade100,
            height: size.width * 0.5,
            width: size.width * 0.5,
            child: imagesFileList != null
                ? previewImages()
                : const Center(
                    child: Text('you have not \n \n picked images yet !',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16)),
                  ),
          ),
          SizedBox(
            height: size.width * 0.5,
            width: size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Text(
                      '* select main category',
                      style: TextStyle(color: Colors.red),
                    ),
                    DropdownButton(
                        iconSize: 40,
                        iconEnabledColor: Colors.red,
                        dropdownColor: Colors.yellow.shade400,
                        value: maincategoryValue,
                        items: maincateg.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          selectedMainCategory(value);
                        }),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '* select subcategory',
                      style: TextStyle(color: Colors.red),
                    ),
                    DropdownButton(
                        iconSize: 40,
                        iconEnabledColor: Colors.red,
                        iconDisabledColor: Colors.black,
                        dropdownColor: Colors.yellow.shade400,
                        menuMaxHeight: 500,
                        disabledHint: const Text('select category'),
                        value: subcategoryValue,
                        items: subcategoryList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          print(value);
                          setState(() {
                            subcategoryValue = value!;
                          });
                        })
                  ],
                ),
              ],
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: imagesFileList!.isNotEmpty
              ? YellowButton(
                  label: 'Reset Images',
                  onPressed: () {
                    setState(() {
                      imagesFileList = [];
                    });
                  },
                  width: 0.6)
              : YellowButton(
                  label: 'Change Images',
                  onPressed: () {
                    pickProductImages();
                  },
                  width: 0.6),
        )
      ],
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.yellow, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10)),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
