import 'package:flutter/material.dart';

class BackGroundImage extends StatelessWidget {
  final String image;
  const BackGroundImage({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}