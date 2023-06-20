import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../minor_screens/product_details.dart';
import '../providers/wish_list_provider.dart';
import 'package:collection/collection.dart';
// Product feed Card

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({
    required this.products,
    super.key,
  });

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    var existingItemWishList =
        context.watch<WishList>().getWishItems.firstWhereOrNull(
              (product) => product.documentId == widget.products['proId'],
            );
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      proList: widget.products,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 100,
                    maxHeight: 250,
                  ),
                  child: Image(
                    image: NetworkImage(widget.products['proimages'][0]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      widget.products['productname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.products['price'].toStringAsFixed(2) + (' \$'),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        widget.products['sid'] == uid
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                color: Colors.red,
                              )
                            : IconButton(
                                onPressed: () {
                                  existingItemWishList != null
                                      ? context
                                          .read<WishList>()
                                          .removeThis(widget.products['proId'])
                                      : context.read<WishList>().addWishItem(
                                            widget.products['productname'],
                                            widget.products['price'],
                                            1,
                                            widget.products['instock'],
                                            widget.products['proimages'],
                                            widget.products['proId'],
                                            widget.products['sid'],
                                          );
                                },
                                icon: existingItemWishList != null
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                      ),
                                color: Colors.red,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
