import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseZopay{
  String status;
  String message;
  ResponseZopay({this.status, this.message});

  ResponseZopay.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final json = snapshot.data();
    this.status = json['status'];
    this.message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': status};
  }
}