import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
      ),

    );
  }
}

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle({required this.title, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      
      style: GoogleFonts.acme(
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 28,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
