// ignore_for_file: depend_on_referenced_packages

import 'package:as_shop/main_screens/cart.dart';
import 'package:as_shop/minor_screens/visit_store.dart';
import 'package:as_shop/providers/wish_list_provider.dart';
import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:as_shop/widgets/snackbar.dart';
import 'package:as_shop/widgets/yellow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'full_screen_view.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badge;

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({required this.proList, Key? key})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late List<dynamic> imagesList = widget.proList['proimages'];
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincategory', isEqualTo: widget.proList['maincategory'])
        .where('subcategory', isEqualTo: widget.proList['subcategory'])
        .snapshots();
    var existingItemCart = context.watch<Cart>().getItems.firstWhereOrNull(
          (product) => product.documentId == widget.proList['proId'],
        );
    var existingItemWishList =
        context.watch<WishList>().getWishItems.firstWhereOrNull(
              (product) => product.documentId == widget.proList['proId'],
            );
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldkey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                    imagesList: imagesList,
                                  )));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                              );
                            },
                            itemCount: imagesList.length,
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          widget.proList['productname'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'USD ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.proList['price'].toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                existingItemWishList != null
                                    ? context
                                        .read<WishList>()
                                        .removeThis(widget.proList['proId'])
                                    : context.read<WishList>().addWishItem(
                                          widget.proList['productname'],
                                          widget.proList['price'],
                                          1,
                                          widget.proList['instock'],
                                          widget.proList['proimages'],
                                          widget.proList['proId'],
                                          widget.proList['sid'],
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
                        widget.proList['instock'] == 0
                            ? const Text(
                                'Out of Stock',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                ),
                              )
                            : Text(
                                '${widget.proList['instock']} pieces available in stock',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.blueGrey),
                              ),
                        const ProDetailsHeader(
                          label: '  Item Description  ',
                        ),
                        SelectableText(
                          widget.proList['prodescription'],
                          textScaleFactor: 1.1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade800),
                        ),
                        const ProDetailsHeader(label: '  Similar Items  '),
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.yellow,
                                  ),
                                );
                              }
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                      'This category \n\n has not items yet !',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.acme(
                                        fontSize: 26,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      )),
                                );
                              }
                              return SingleChildScrollView(
                                child: StaggeredGridView.countBuilder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  crossAxisCount: 2,
                                  itemBuilder: (context, index) {
                                    return ProductModel(
                                      products: snapshot.data!.docs[index],
                                    );
                                  },
                                  staggeredTileBuilder: (context) =>
                                      const StaggeredTile.fit(1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisitStore(
                                      supplierId: widget.proList['sid'])));
                        },
                        icon: const Icon(Icons.store),
                      ),
                      SizedBox(
                        width: 20,
                        child: IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(
                                back: AppBarBackButton(),
                              ),
                            ),
                          ),
                          icon: badge.Badge(
                            badgeAnimation: const badge.BadgeAnimation.slide(),
                            position: badge.BadgePosition.custom(
                              start: 10,
                              bottom: 9,
                              isCenter: false,
                            ),
                            badgeStyle: const badge.BadgeStyle(
                              badgeColor: Colors.yellow,
                              padding: EdgeInsets.all(3),
                            ),
                            showBadge: context.watch<Cart>().getItems.isEmpty
                                ? false
                                : true,
                            badgeContent: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                context
                                    .watch<Cart>()
                                    .getItems
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.shopping_cart),
                          ),
                        ),
                      ),
                    ],
                  ),
                  YellowButton(
                    label: widget.proList['instock'] <= 0
                        ? 'Out of Stock'
                        : existingItemCart != null
                            ? 'Added to Cart'
                            : 'ADD TO CART',
                    onPressed: (widget.proList['instock'] <= 0)
                        ? null
                        : () => existingItemCart != null
                            ? MyMessageHandler.showSnackBar(
                                _scaffoldkey,
                                'This item is already in the cart.',
                              )
                            : context.read<Cart>().addItem(
                                  widget.proList['productname'],
                                  widget.proList['price'],
                                  1,
                                  widget.proList['instock'],
                                  widget.proList['proimages'],
                                  widget.proList['proId'],
                                  widget.proList['sid'],
                                ),
                    width: 0.55,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
