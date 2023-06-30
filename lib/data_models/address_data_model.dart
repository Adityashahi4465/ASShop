// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Address {
  final String country;
  final String state;
  final String city;
  final String firstName;
  final String lastName;
  final String phone;
  final String houseNumber;
  final String street;
  final String postalCode;
  final bool isDefault;
  final String id;
  Address({
    required this.country,
    required this.state,
    required this.city,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.houseNumber,
    required this.street,
    required this.postalCode,
    required this.isDefault,
    required this.id,
  });

  Address copyWith({
    String? country,
    String? state,
    String? city,
    String? firstName,
    String? lastName,
    String? phone,
    String? houseNumber,
    String? street,
    String? postalCode,
    bool? isDefault,
    String? id,
  }) {
    return Address(
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      houseNumber: houseNumber ?? this.houseNumber,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'state': state,
      'city': city,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'houseNumber': houseNumber,
      'street': street,
      'postalCode': postalCode,
      'isDefault': isDefault,
      'id': id,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      country: map['country'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phone: map['phone'] as String,
      houseNumber: map['houseNumber'] as String,
      street: map['street'] as String,
      postalCode: map['postalCode'] as String,
      isDefault: map['isDefault'] as bool,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Address(country: $country, state: $state, city: $city, firstName: $firstName, lastName: $lastName, phone: $phone, houseNumber: $houseNumber, street: $street, postalCode: $postalCode, isDefault: $isDefault, id: $id)';
  }

  String getFormattedAddress() {
    return '$houseNumber, $state, $city - $postalCode, $country';
  }
}
