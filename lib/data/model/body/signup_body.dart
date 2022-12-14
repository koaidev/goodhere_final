class SignUpBody {
  late String fName;
  late String lName;
  late String phone;
  late String email;
  late String password;
  late String refCode;

  SignUpBody(
      {required this.fName,
      required this.lName,
      required this.phone,
      this.email = '',
      required this.password,
      this.refCode = ''});

  SignUpBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    refCode = json['ref_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['ref_code'] = this.refCode;
    return data;
  }
}
