import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

//for zp
class UserInfoZopay {
  String name;
  String phone;
  String email;
  String pin;
  String referralCode;
  String role;
  String uid;
  String fcmToken;
  String image;
  String verifyStatus;
  String qrCode;

  UserInfoZopay({@required this.name,
    @required this.phone,
    this.email,
    @required this.pin,
    @required this.referralCode,
    this.role,
    @required this.uid,
    this.fcmToken,
    this.image,
    this.verifyStatus,
    @required this.qrCode});

  UserInfoZopay.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final json = snapshot.data();

    this.name = json['name'];
    this.phone = json['phone'];
    this.email = json['email'];
    this.pin = json['pin'];
    this.referralCode = json['referral_code'];
    this.role = json['role'];
    this.uid = json['uid'];
    this.fcmToken = json['fcm_token'];
    this.image = json['image'];
    this.verifyStatus = json['verify_status'];
    this.qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'pin': pin,
      'referral_code': referralCode,
      'role': role,
      'uid': uid,
      'fcm_token': fcmToken,
      'image': image,
      'verify_status': verifyStatus,
      'qr_code': qrCode
    };
  }
}
