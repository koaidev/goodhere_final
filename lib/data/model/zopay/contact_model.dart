

class ContactModel {
  ContactModel({
    this.phoneNumber,
    this.name,
    this.avatarImage,
  });

  String phoneNumber;
  String name;
  String avatarImage;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        phoneNumber: json["phoneNumber"],
        name: json["name"],
        avatarImage: json["avatarImage"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "name": name,
        "avatarImage": avatarImage,
      };
}
