import 'package:flutter/material.dart';

import '../../../pallet/colors.dart';

class GradientDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 2,
          color: Pallet.boarderColor,
        ),
        const SizedBox(width: 11),
        Container(
          width: 20,
          height: 2,
          color: Pallet.lightBlack,
        ),
        const SizedBox(width: 10),
        Container(
          width: 18,
          height: 2.5,
          color: Pallet.lightBlack,
        ),
      ],
    );
  }
}