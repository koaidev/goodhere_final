import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../controller/zopay/home_controller.dart';
import '../../../../../../data/model/zopay/user_info.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';

class ShowName extends StatelessWidget {
  final UserInfoZopay userInfoZopay;

  const ShowName({Key key, @required this.userInfoZopay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            'Chào ${userInfoZopay.name}',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: robotoRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                color: ColorResources.whiteColor),
          ),
        ),

        GetBuilder<HomeController>(builder: (controller) {
          return Text(
            '${controller.greetingMessage()}',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              color: ColorResources.whiteColor.withOpacity(0.5),
            ),
          );
        }),
      ],
    );
  }
}
