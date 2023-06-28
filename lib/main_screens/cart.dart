// ignore_for_file: use_build_context_synchronously

import 'package:as_shop/minor_screens/place_order/place_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wish_list_provider.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/my_alert_dialog.dart';
import '../widgets/yellow_button.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({
    this.back,
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Your Cart'),
            centerTitle: true,
            leading: widget.back,
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context: context,
                          title: 'Clear Cart',
                          content: 'Are you sure to clear cart',
                          tabNo: () {
                            Navigator.pop(context);
                          },
                          tabYes: () {
                            Navigator.pop(context);
                            context.read<Cart>().clearCart();
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
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total: \$',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      context.watch<Cart>().totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                YellowButton(
                    label: 'CHECK OUT',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceOrderScreen(),
                        ),
                      );
                    },
                    width: 0.45)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart is Empty!',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return ListView.builder(
          itemCount: cart.getItems.length,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
            var existingItemWishList =
                context.watch<WishList>().getWishItems.firstWhereOrNull(
                      (element) => element.documentId == product.documentId,
                    );
            return CartModel(
              product: product,
              existingItemWishList: existingItemWishList,
              cart: context.read<Cart>(),
            );
          });
    });
  }
}
