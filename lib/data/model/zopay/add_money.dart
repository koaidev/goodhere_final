import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddMoney {
  String id;
  String uid;
  String name;
  String image;
  int amount;
  int dateCreate;
  int dateComplete;
  String status;

  AddMoney(
      {@required this.id,
      @required this.uid,
      @required this.name,
      @required this.image,
      @required this.amount,
      @required this.dateCreate,
      this.dateComplete,
      @required this.status});

  factory AddMoney.fromJson(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return AddMoney(
        id: data['id'],
        uid: data['uid'],
        name: data['name'],
        image: data['image'],
        amount: data['amount'],
        dateCreate: data['dateCreate'],
        dateComplete: data['dateComplete'],
        status: data['status']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'image': image,
      'amount': amount,
      'dateCreate': dateCreate,
      'dateComplete': dateComplete,
      'status': status
    };
  }
}
