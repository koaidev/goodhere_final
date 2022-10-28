import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/preview_contact_tile.dart';

import '../../../../../../data/model/zopay/contact_model.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';

class ForPersonWidget extends StatelessWidget {
  final ContactModel contactModel;
  const ForPersonWidget({Key key, this.contactModel, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.getBackgroundColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT, left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE),
            child: Text('for_person'.tr, style: notoSerifBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getGreyBaseGray1())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: PreviewContactTile(contactModel: contactModel)),
            ],
          ),
              
          Container(height: Dimensions.DIVIDER_SIZE_MEDIUM, color: ColorResources.BACKGROUND_COLOR),


        ],
      ),
    );
  }
}
