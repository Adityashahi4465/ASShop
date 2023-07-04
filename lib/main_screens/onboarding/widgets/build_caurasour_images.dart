import 'package:flutter/material.dart';

import '../../../pallet/colors.dart';

class BuildImages extends StatelessWidget {
  final String imageUrl;
  final int index;
  final VoidCallback? onTap;
  const BuildImages({
    super.key,
    required this.imageUrl,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            width: 2.5,
            color: Pallet.boarderColor,
          ),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
