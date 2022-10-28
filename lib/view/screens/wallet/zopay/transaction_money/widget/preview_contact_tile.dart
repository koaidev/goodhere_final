import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../controller/auth_controller.dart';
import '../../../../../../data/model/zopay/contact_model.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';

class PreviewContactTile extends StatelessWidget {
  final ContactModel contactModel;
  const PreviewContactTile({Key key, @required this.contactModel,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String phoneNumber = contactModel.phoneNumber;
    if(phoneNumber.contains('-')){
      phoneNumber.replaceAll('-', '');
    }
    return ListTile(
        title:  Text(contactModel.name==null?phoneNumber: contactModel.name, style: notoSerifRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        subtitle:phoneNumber.length<=0? SizedBox():
          Text(phoneNumber, style: notoSerifRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getGreyBaseGray1()),),
      );
  }
}



