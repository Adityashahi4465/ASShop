import 'package:as_shop/auth/customer_login.dart';
import 'package:as_shop/auth/supplier_login.dart';
import 'package:as_shop/auth/supplier_signup.dart';
import 'package:as_shop/customer_screens/customer_orders.dart';
import 'package:as_shop/customer_screens/whishlist.dart';
import 'package:as_shop/auth/customer_signup.dart';
import 'package:as_shop/dashboard_components/edit_business.dart';
import 'package:as_shop/dashboard_components/manage_products.dart';
import 'package:as_shop/dashboard_components/my_store.dart';
import 'package:as_shop/main_screens/cart.dart';
import 'package:as_shop/main_screens/supplier_home.dart';
import 'package:as_shop/main_screens/welcome_screen.dart';
import 'package:as_shop/providers/cart_provider.dart';
import 'package:as_shop/providers/wish_list_provider.dart';
import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_components/supplier_balance.dart';
import 'dashboard_components/supplier_orders.dart';
import 'dashboard_components/supplier_statics.dart';
import 'firebase_options.dart';
import 'main_screens/customer_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => WishList()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASShop',
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/supplier_login': (context) => const SupplierLogin(),
        '/supplier_signup': (context) => const SupplierRegister(),
        '/edit_business': (context) => const EditBusiness(),
        '/manage_products': (context) => const ManageProducts(),
        '/my_store': (context) => const MyStore(),
        'supplier_balance': (context) => const BalanceScreen(),
        '/supplier_orders': (context) => const SupplierOrders(),
        '/supplier_statics': (context) => const StaticsScreen(),
        '/cart_screen': (context) => const CartScreen(
              back: AppBarBackButton(),
            ),
        '/wishlist_screen': (context) => const WishListScreen(),
        '/customer_orders': (context) => const CustomerOrders(),
      },
    );
  }
}
