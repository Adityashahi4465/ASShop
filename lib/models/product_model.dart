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
    var onSale = widget.products['discount'];
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
        child: Stack(
          children: [
            Container(
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '\$',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      widget.products['price']
                                          .toStringAsFixed(2),
                                      style: onSale != 0
                                          ? const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            )
                                          : const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    widget.products['discount'] != 0
                                        ? Text(
                                            // calculating price after discount
                                            ((1 - (onSale / 100)) *
                                                    widget.products['price'])
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : const Text(''),
                                  ],
                                ),
                              ],
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
                                          ? context.read<WishList>().removeThis(
                                              widget.products['proId'])
                                          : context
                                              .read<WishList>()
                                            .addWishItem(
                                                widget.products['productname'],
                                                onSale != 0
                                                    ? ((1 - (onSale / 100)) *
                                                        widget
                                                            .products['price'])
                                                    : widget.products['price'],
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
            onSale != 0
                ? Positioned(
                    top: 20,
                    left: 0,
                    child: Container(
                      height: 25,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                            'Save ${widget.products['discount'].toString()} %'),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  ),
          ],
        ),
      ),
    );
  }
}
