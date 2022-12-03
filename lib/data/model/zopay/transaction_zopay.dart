import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TransactionType {
  static const String TYPE_NEED_HANDLE = "need_handle";
  static const String TYPE_PAYMENT = "payment";
  static const String TYPE_TRANSFER = "transfer";
  static const String TYPE_DISCOUNT = "discount";
}

class TransactionZopay {
  String transactionId; //datecreate+ random 3 ký tự trong bảng chữ cái
  String uidSender;
  String uidReceiver;
  String orderId;
  String nameReceiver;
  String phoneReceiver;
  int amount;
  int createdAt;
  int completeAt;
  String status;
  String message;
  String typeTransaction;

  TransactionZopay(
      {@required this.transactionId,
      @required this.uidSender,
      @required this.uidReceiver,
      this.orderId,
      @required this.amount,
      @required this.createdAt,
      @required this.phoneReceiver,
      @required this.nameReceiver,
      this.completeAt = 0,
      this.status = TransactionType.TYPE_NEED_HANDLE,
      this.message,
      @required this.typeTransaction});

  TransactionZopay.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final json = snapshot.data();

    this.transactionId = json['transaction_id'];
    this.uidSender = json['uid_sender'];
    this.uidReceiver = json['uid_receiver'];
    this.amount = json['amount'];
    this.createdAt = json['create_at'];
    this.completeAt = json['complete_at'];
    this.status = json['status'];
    this.message = json['message'];
    this.typeTransaction = json['type_transaction'];
    this.nameReceiver = json['name_receiver'];
    this.phoneReceiver = json['phone_receiver'];
    this.orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'uid_sender': uidSender,
      'uid_receiver': uidReceiver,
      'amount': amount,
      'create_at': createdAt,
      'complete_at': completeAt,
      'status': status,
      'message': message,
      'type_transaction': typeTransaction,
      'name_receiver': nameReceiver,
      'phone_receiver': phoneReceiver,
      'order_id': orderId
    };
  }
}