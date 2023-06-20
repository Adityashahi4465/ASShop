import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_class.dart';
import '../providers/wish_list_provider.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    super.key,
    required this.product,
    required this.existingItemWishList,
    required this.cart
  });
  final Cart cart;
  final Product product;
  final Product? existingItemWishList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: Image.network(
                 product.imagesUrl.first,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.price.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                product.qty == 1
                                    // delete Item or move to wishlist
                                    ? IconButton(
                                        onPressed: () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoActionSheet(
                                              title: const Text(
                                                'RemoveItem',
                                              ),
                                              message: const Text(
                                                'Are you sure to delete this Item ?',
                                              ),
                                              actions: <Widget>[
                                                CupertinoActionSheetAction(
                                                  child: const Text(
                                                    'Move to Wishlist',
                                                  ),
                                                  onPressed: () async {
                                                    existingItemWishList != null
                                                        ? context
                                                            .read<Cart>()
                                                            .removeItem(
                                                              product,
                                                            )
                                                        : await context
                                                            .read<WishList>()
                                                            .addWishItem(
                                                              product.name,
                                                              product.price,
                                                              1,
                                                              product.qntty,
                                                              product.imagesUrl,
                                                              product
                                                                  .documentId,
                                                              product.suppId,
                                                            );
                                                    context
                                                        .read<Cart>()
                                                        .removeItem(
                                                          product,
                                                        );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: const Text(
                                                    'Delete Item',
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<Cart>()
                                                        .removeItem(
                                                          product,
                                                        );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                              cancelButton: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          size: 18,
                                        ),
                                      )
                                    // decrease the quantity of product
                                    : IconButton(
                                        onPressed: () {
                                          cart.decrement(product);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.minus,
                                          size: 18,
                                        ),
                                      ),
                                Text(
                                  product.qty.toString(),
                                  style: product.qty == product.qntty
                                      ? const TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                        )
                                      : const TextStyle(
                                          fontSize: 20,
                                        ),
                                ),
                                IconButton(
                                  onPressed: product.qty == product.qntty
                                      ? null
                                      : () {
                                          cart.increment(product);
                                        },
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
