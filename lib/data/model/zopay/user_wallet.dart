import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sixam_mart/data/model/zopay/referral.dart';

class UserWallet {
  String uid;
  int pointPromotion;
  int pointMain;
  List<Referral> listReferral;
  int joinTime = DateTime.now().millisecondsSinceEpoch;

  UserWallet(
      {@required this.uid,
      this.pointPromotion = 0,
      this.pointMain = 0,
      this.listReferral,
      this.joinTime});

  UserWallet.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final json = snapshot.data();
    this.uid = json['uid'];
    this.pointPromotion = json['point_promotion'];
    this.pointMain = json['point_main'];
    if (json['list_referral'] != null) {
      listReferral = <Referral>[];
      json['list_referral'].forEach(( v) {
        listReferral.add(new Referral.fromJson(v, null));
      });
    }
    this.joinTime = json['join_time'];
  }

  Map<String, dynamic> toJson() {

    return {
      'uid': uid,
      'point_promotion': pointPromotion,
      'point_main': pointMain,
      'list_referral' : this.listReferral.map((v) => v.toJson()).toList(),
      'join_time': joinTime
    };
  }
}
