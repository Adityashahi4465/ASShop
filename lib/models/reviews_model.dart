import 'package:flutter/material.dart';

class ReviewModel extends StatelessWidget {
  final String feedback;
  final String rating;
  final String proImage;
  final String name;
  final String email;
  const ReviewModel(
      {super.key,
      required this.feedback,
      required this.rating,
      required this.proImage,
      required this.name,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(proImage),
      ),
      title: Text(name),
     subtitle : Expanded(
        child: Text(
          feedback,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
      trailing: Column(
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          Text(
            "${rating}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
