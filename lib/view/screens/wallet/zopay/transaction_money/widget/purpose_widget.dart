import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/purpose_item.dart';

import '../../../../../../controller/localization_controller.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../../../../base/custom_loader.dart';

class PurposeWidget extends StatelessWidget {
  const PurposeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE,
              vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(
            'select_your_purpose'.tr,
            style:
                robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
        ),
        Container(
          height: 150,
          padding: localizationController.isLtr
              ? EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT)
              : EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  PurposeItem(
                      onTap: (){},
                      image: Images.zopay_coin,
                      title: "test purpose item",
                      color: Colors.amber),
                  Visibility(
                      visible: true,
                      child: Positioned(
                          top: Dimensions.PADDING_SIZE_DEFAULT,
                          right: Dimensions.PADDING_SIZE_DEFAULT,
                          child: Image.asset(Images.on_select,
                              height: 12, width: 12)))
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
