// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Review {
  String name;
  String email;
  double rating;
  String feedback;
  String profileimage;
  Review({
    required this.name,
    required this.email,
    required this.rating,
    required this.feedback,
    required this.profileimage,
  });

  Review copyWith({
    String? name,
    String? email,
    double? rating,
    String? feedback,
    String? profileimage,
  }) {
    return Review(
      name: name ?? this.name,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      profileimage: profileimage ?? this.profileimage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'rating': rating,
      'feedback': feedback,
      'profileimage': profileimage,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      name: map['name'] as String,
      email: map['email'] as String,
      rating: map['rating'] as double,
      feedback: map['feedback'] as String,
      profileimage: map['profileimage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Review(name: $name, email: $email, rating: $rating, feedback: $feedback, profileimage: $profileimage)';
  }
}
