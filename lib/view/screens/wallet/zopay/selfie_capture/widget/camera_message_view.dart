import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';

class CameraMessageView extends StatelessWidget {
  const CameraMessageView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
        vertical: Dimensions.PADDING_SIZE_SMALL,
      ),
      decoration: BoxDecoration(
          color: ColorResources.getWhiteColor(),
          borderRadius:
              BorderRadius.circular(Dimensions.RADIUS_SIZE_VERY_SMALL)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'take_a_selfie'.tr,
            style: notoSerifRegular.copyWith(
              color: ColorResources.getPrimaryColor(),
              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
            ),
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_SMALL,
          ),
          Text(
            'place_your_face_inside_the_frame_camera_will_auto_capture_your_face_upon_eye_blinking'
                .tr,
            style: notoSerifRegular.copyWith(
              color: ColorResources.getOnboardGreyColor(),
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
            ),
          ),
        ],
      ),
    );
  }
}
