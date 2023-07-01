import 'dart:convert';

class Supplier {
  final String storename;
  final String email;
  final String storelogo;
  final String phone;
  final String sid;
  final String coverimage;
  Supplier({
    required this.storename,
    required this.email,
    required this.storelogo,
    required this.phone,
    required this.sid,
    required this.coverimage,
  });

  Supplier copyWith({
    String? storename,
    String? email,
    String? storelogo,
    String? phone,
    String? sid,
    String? coverimage,
  }) {
    return Supplier(
      storename: storename ?? this.storename,
      email: email ?? this.email,
      storelogo: storelogo ?? this.storelogo,
      phone: phone ?? this.phone,
      sid: sid ?? this.sid,
      coverimage: coverimage ?? this.coverimage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'storename': storename,
      'email': email,
      'storelogo': storelogo,
      'phone': phone,
      'sid': sid,
      'coverimage': coverimage,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      storename: map['storename'] as String,
      email: map['email'] as String,
      storelogo: map['storelogo'] as String,
      phone: map['phone'] as String,
      sid: map['sid'] as String,
      coverimage: map['coverimage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Supplier.fromJson(String source) =>
      Supplier.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Supplier(storename: $storename, email: $email, storelogo: $storelogo, phone: $phone, sid: $sid, coverimage: $coverimage)';
  }
}
