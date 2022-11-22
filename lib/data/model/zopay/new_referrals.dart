import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NewReferral {
  String phoneSender;
  String phoneReceiver;
  bool status = false;
  String id;

  NewReferral(
      {@required this.phoneSender,
      @required this.phoneReceiver,
      this.status,
      @required this.id});

  NewReferral.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final json = snapshot.data();
    this.phoneSender = json['phone_sender'];
    this.phoneReceiver = json['phone_receiver'];
    this.status = json['status'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_sender': phoneSender,
      'phone_receiver': phoneReceiver,
      'status': status,
      'id': id
    };
  }
}
