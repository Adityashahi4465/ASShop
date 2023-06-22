// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDataClass {
  String cid;
  String custname;
  String email;
  String address;
  String phone;
  String profileimage;
  String sid;
  String proid;
  String orderid;
  String ordername;
  String orderimage;
  int orderqty;
  double orderprice;
  String deliverystatus;
  Timestamp deliverydate;
  Timestamp orderdate;
  String paymentstatus;
  bool orderreview;
  OrderDataClass({
    required this.cid,
    required this.custname,
    required this.email,
    required this.address,
    required this.phone,
    required this.profileimage,
    required this.sid,
    required this.proid,
    required this.orderid,
    required this.ordername,
    required this.orderimage,
    required this.orderqty,
    required this.orderprice,
    required this.deliverystatus,
    required this.deliverydate,
    required this.orderdate,
    required this.paymentstatus,
    required this.orderreview,
  });

  OrderDataClass copyWith({
    String? cid,
    String? custname,
    String? email,
    String? address,
    String? phone,
    String? profileimage,
    String? sid,
    String? proid,
    String? orderid,
    String? ordername,
    String? orderimage,
    int? orderqty,
    double? orderprice,
    String? deliverystatus,
    Timestamp? deliverydate,
    Timestamp? orderdate,
    String? paymentstatus,
    bool? orderreview,
  }) {
    return OrderDataClass(
      cid: cid ?? this.cid,
      custname: custname ?? this.custname,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      profileimage: profileimage ?? this.profileimage,
      sid: sid ?? this.sid,
      proid: proid ?? this.proid,
      orderid: orderid ?? this.orderid,
      ordername: ordername ?? this.ordername,
      orderimage: orderimage ?? this.orderimage,
      orderqty: orderqty ?? this.orderqty,
      orderprice: orderprice ?? this.orderprice,
      deliverystatus: deliverystatus ?? this.deliverystatus,
      deliverydate: deliverydate ?? this.deliverydate,
      orderdate: orderdate ?? this.orderdate,
      paymentstatus: paymentstatus ?? this.paymentstatus,
      orderreview: orderreview ?? this.orderreview,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'custname': custname,
      'email': email,
      'address': address,
      'phone': phone,
      'profileimage': profileimage,
      'sid': sid,
      'proid': proid,
      'orderid': orderid,
      'ordername': ordername,
      'orderimage': orderimage,
      'orderqty': orderqty,
      'orderprice': orderprice,
      'deliverystatus': deliverystatus,
      'deliverydate': deliverydate.toDate(),
      'orderdate': orderdate.toDate(),
      'paymentstatus': paymentstatus,
      'orderreview': orderreview,
    };
  }

  factory OrderDataClass.fromMap(Map<String, dynamic> map) {
    return OrderDataClass(
      cid: map['cid'] as String,
      custname: map['custname'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      profileimage: map['profileimage'] as String,
      sid: map['sid'] as String,
      proid: map['proid'] as String,
      orderid: map['orderid'] as String,
      ordername: map['ordername'] as String,
      orderimage: map['orderimage'] as String,
      orderqty: map['orderqty'] as int,
      orderprice: map['orderprice'] as double,
      deliverystatus: map['deliverystatus'] as String,
      deliverydate: map['deliverydate'] as Timestamp,
      orderdate: map['orderdate'] as Timestamp,
      paymentstatus: map['paymentstatus'] as String,
      orderreview: map['orderreview'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDataClass.fromJson(String source) =>
      OrderDataClass.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderDataClass(cid: $cid, custname: $custname, email: $email, address: $address, phone: $phone, profileimage: $profileimage, sid: $sid, proid: $proid, orderid: $orderid, ordername: $ordername, orderimage: $orderimage, orderqty: $orderqty, orderprice: $orderprice, deliverystatus: $deliverystatus, deliverydate: $deliverydate, orderdate: $orderdate, paymentstatus: $paymentstatus, orderreview: $orderreview)';
  }

  @override
  bool operator ==(covariant OrderDataClass other) {
    if (identical(this, other)) return true;

    return other.cid == cid &&
        other.custname == custname &&
        other.email == email &&
        other.address == address &&
        other.phone == phone &&
        other.profileimage == profileimage &&
        other.sid == sid &&
        other.proid == proid &&
        other.orderid == orderid &&
        other.ordername == ordername &&
        other.orderimage == orderimage &&
        other.orderqty == orderqty &&
        other.orderprice == orderprice &&
        other.deliverystatus == deliverystatus &&
        other.deliverydate == deliverydate &&
        other.orderdate == orderdate &&
        other.paymentstatus == paymentstatus &&
        other.orderreview == orderreview;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        custname.hashCode ^
        email.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        profileimage.hashCode ^
        sid.hashCode ^
        proid.hashCode ^
        orderid.hashCode ^
        ordername.hashCode ^
        orderimage.hashCode ^
        orderqty.hashCode ^
        orderprice.hashCode ^
        deliverystatus.hashCode ^
        deliverydate.hashCode ^
        orderdate.hashCode ^
        paymentstatus.hashCode ^
        orderreview.hashCode;
  }
}
