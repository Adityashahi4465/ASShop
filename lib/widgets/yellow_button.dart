import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final double width;

  const YellowButton({
    required this.label,
    required this.onPressed,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(25),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
