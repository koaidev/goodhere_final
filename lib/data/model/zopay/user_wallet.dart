import 'package:cloud_firestore/cloud_firestore.dart';

class UserWallet {
  String uid;
  int pointPromotion;
  int pointMain;

  UserWallet({
    this.pointPromotion,
    this.pointMain,
  });

  UserWallet.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final json = snapshot.data();
    this.uid = json['uid'];
    this.pointPromotion = json['point_promotion'];
    this.pointMain = json['point_main'];
  }

  Map<String, dynamic> toJson() {
    return{
      'uid': uid,
      'point_promotion': pointPromotion,
      'point_main': pointMain,
    };
  }
}
