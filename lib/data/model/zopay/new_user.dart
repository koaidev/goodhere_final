import 'package:cloud_firestore/cloud_firestore.dart';

class NewUser{
  String uid;
  bool status;

  NewUser.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options){
    final json = snapshot.data();
    this.uid = json['uid'];
    this.status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return{
      'uid': uid,
      'status': status
    };
  }
}