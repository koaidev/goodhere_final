import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstBuy {
  String uid;
  String status;
  String phone;

  FirstBuy({@required this.uid, @required this.status, @required this.phone});

  FirstBuy.fromJson(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final json = snapshot.data();
    this.uid = json["uid"];
    this.status = json["status"];
    this.phone = json["phone"] ?? null;
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "status": status,
        "phone": phone,
      };
}
