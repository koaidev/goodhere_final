import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../util/dimensions.dart';

class DemoOtpHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      child: Text(
        'for_demo_1234'.tr,
        style: robotoMedium.copyWith(
            fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Colors.black54),
      ),
    );
  }
}
