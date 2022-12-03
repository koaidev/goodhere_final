import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ABank {
  String bankName;
  String noCard;
  String branch;
  String cardUserName;
  String cartExpDate;
  int cardCode;
  String uid;

  ABank(
      {@required this.bankName,
      @required this.noCard,
      @required this.cardUserName,
      @required this.branch,
      this.cartExpDate,
      this.cardCode,
      @required this.uid});

  factory ABank.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions options,
  ) {
    final data = snapshot.data();
    return ABank(
        bankName: data['bank_name'],
        noCard: data['no_card'],
        cardUserName: data['card_user_name'],
        cartExpDate: data['cart_exp_date'],
        cardCode: data['card_code'],
        uid: data['uid'],
        branch: data['branch']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (bankName != null) "bank_name": bankName,
      if (noCard != null) "no_card": noCard,
      if (cardUserName != null) "card_user_name": cardUserName,
      "cart_exp_date": cartExpDate,
      "card_code": cardCode,
      if (uid != null) "uid": uid,
    };
  }
}
