import 'dart:convert';

class Customer {
  final String name;
  final String email;
  final String profileimage;
  final String phone;
  final String address;
  final String cid;
  Customer({
    required this.name,
    required this.email,
    required this.profileimage,
    required this.phone,
    required this.address,
    required this.cid,
  });

  Customer copyWith({
    String? name,
    String? email,
    String? profileimage,
    String? phone,
    String? address,
    String? cid,
  }) {
    return Customer(
      name: name ?? this.name,
      email: email ?? this.email,
      profileimage: profileimage ?? this.profileimage,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      cid: cid ?? this.cid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'profileimage': profileimage,
      'phone': phone,
      'address': address,
      'cid': cid,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'] as String,
      email: map['email'] as String,
      profileimage: map['profileimage'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      cid: map['cid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Customer(name: $name, email: $email, profileimage: $profileimage, phone: $phone, address: $address, cid: $cid)';
  }
}
