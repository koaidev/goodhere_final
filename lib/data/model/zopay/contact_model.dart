import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  ContactModel({
    this.phoneNumber,
    this.name,
    this.avatarImage,
  });

  String phoneNumber;
  String name;
  String avatarImage;

  ContactModel.fromJson(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final json = snapshot.data();
    this.phoneNumber = json["phone_number"];
    this.name = json["name"];
    this.avatarImage = json["avatar_image"] ?? null;
  }

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "name": name,
        "avatar_image": avatarImage,
      };
}
