import 'package:flutter/material.dart';

import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../base/zopay/custom_ink_well.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSubmittable;
  const NextButton({Key key, @required this.isSubmittable, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: onTap,
      radius:  Dimensions.RADIUS_PROFILE_AVATAR,
      child: CircleAvatar(
        maxRadius: Dimensions.RADIUS_PROFILE_AVATAR,
        backgroundColor:isSubmittable ?  Colors.green: ColorResources.getGreyBaseGray6(),
        child: Icon(Icons.arrow_forward, color: ColorResources.whiteColor)),
    );
  }
}