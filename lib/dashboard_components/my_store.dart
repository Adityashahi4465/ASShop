import 'package:as_shop/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class MyStore extends StatelessWidget {
  const MyStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(
          title: 'My Store',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
