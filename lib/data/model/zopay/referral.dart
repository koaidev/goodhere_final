import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Referral {
  String referralUser;
  int moneyGetNow; //lấy từ admin
  //người dùng được phép tạo lệnh yêu cầu lên admin, admin phê duyệt và trả lại kết quả vào trong user
  //chỉ có quyền đọc, ko có quyền tạo, update, xóa.

  Referral({@required this.referralUser, this.moneyGetNow = 0});

  Referral.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final json = snapshot.data();
    this.referralUser = json['referral_user'];
    this.moneyGetNow = json['money_get_now'];
  }

  Map<String, dynamic> toJson() {
    return {'referral_user': referralUser, 'money_get_now': moneyGetNow};
  }
}
