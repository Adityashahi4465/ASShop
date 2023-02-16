import 'package:flutter/material.dart';

import '../widgets/appbar_widgets.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(
          title: 'Balance Screen',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
