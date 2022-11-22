import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';

class ShowBalance extends StatelessWidget {
  const ShowBalance({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Balance",
            style: robotoBlack.copyWith(
              color: ColorResources.whiteColor,
              fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
            )),
        // Text(PriceConverter.balanceWithSymbol(balance: '0.0'), style: rubikMedium.copyWith(color: ColorResources.whiteColor, fontSize: Dimensions.FONT_SIZE_OVER_LARGE,)
        //   ),FONT_SIZE_OVER_LARGE
        const SizedBox(
          height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
        Text('available_balance'.tr,
            style: robotoRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: ColorResources.whiteColor))
      ],
    );
  }
}
