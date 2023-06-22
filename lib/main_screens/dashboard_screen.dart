import 'package:as_shop/dashboard_components/edit_business.dart';
import 'package:as_shop/dashboard_components/manage_products.dart';
import 'package:as_shop/dashboard_components/supplier_balance.dart';
import 'package:as_shop/dashboard_components/supplier_orders.dart';
import 'package:as_shop/dashboard_components/supplier_statics.dart';
import 'package:as_shop/minor_screens/visit_store.dart';
import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/my_alert_dialog.dart';

List<String> label = [
  'my store',
  'orders',
  'edit profile',
  'manage product',
  'balance',
  'statics',
];
List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];
List pages = [
  VisitStore(supplierId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditBusiness(),
  const ManageProducts(),
  const BalanceScreen(),
  const StaticsScreen(),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          // The user is logged out, so reload the user.
          await FirebaseAuth.instance.currentUser!.reload();
        }
      });
      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/welcome_screen');
    } catch (e) {
      print('Error Occurred during sign Out $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              MyAlertDialog.showMyDialog(
                context: context,
                title: 'Log Out',
                content: 'Are you sure to log out ?',
                tabNo: () => Navigator.pop(context),
                tabYes: () => signOut(context),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 40,
          crossAxisSpacing: 40,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pages[index],
                ),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(4, 4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        icons[index],
                        color: Colors.grey[700],
                        size: 50,
                      ),
                      Text(
                        label[index].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  )),
            );
          }),
        ),
      ),
    );
  }
}
