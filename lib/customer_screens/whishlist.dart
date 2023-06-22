import 'package:as_shop/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wish_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/appbar_widgets.dart';
import 'package:collection/collection.dart';

import '../widgets/my_alert_dialog.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'WishList'),
            centerTitle: true,
            leading: const AppBarBackButton(),
            actions: [
              context.watch<WishList>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context: context,
                          title: 'Clear Wishlist',
                          content: 'Are you sure to clear wishlist ?',
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () {
                            Navigator.pop(context);
                            context.read<WishList>().clearWishList();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
            ],
          ),
          body: context.watch<WishList>().getWishItems.isNotEmpty
              ? const WishListItems()
              : const EmptyWishList(),
        ),
      ),
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your WishList is Empty!',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

class WishListItems extends StatelessWidget {
  const WishListItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WishList>(builder: (context, wish, child) {
      return ListView.builder(
          itemCount: wish.getWishItems.length,
          itemBuilder: (context, index) {
            final product = wish.getWishItems[index];
            var existingItemCart =
                context.watch<Cart>().getItems.firstWhereOrNull(
                      (element) => element.documentId == product.documentId,
                    );
            return WishlistModel(
                product: product, existingItemCart: existingItemCart);
          });
    });
  }
}
