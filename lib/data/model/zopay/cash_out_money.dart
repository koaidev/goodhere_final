import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CashOutMoney {
  String id;
  String uid;
  String holderName;
  String bankName;
  String bankNumber;
  int amount;
  int dateCreate;
  int dateComplete;
  String status;

  CashOutMoney(
      {@required this.id,
      @required this.uid,
      @required this.holderName,
      @required this.bankName,
      @required this.bankNumber,
      @required this.amount,
      @required this.dateCreate,
      this.dateComplete,
      @required this.status});
  factory CashOutMoney.fromFirestore( DocumentSnapshot<Map<String, dynamic>> snapshot,){
    final data = snapshot.data();
    return CashOutMoney(
        id: data['id'],
        uid: data['uid'],
        holderName: data['holderName'],
        bankName: data['bankName'],
        bankNumber: data['bankNumber'],
        amount: data['amount'],
        dateCreate: data['dateCreate'],
        dateComplete: data['dateComplete'],
        status: data['status']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'uid': uid,
      'holderName': holderName,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'amount': amount,
      'dateCreate': dateCreate,
      'dateComplete': dateComplete,
      'status': status
    };
  }

}
