import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../controller/auth_controller.dart';
import '../../../util/color_resources.dart';
import '../../../util/dimensions.dart';
import '../custom_button.dart';

class CustomDialog extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String title;
  final String description;
  final Function onTapTrue;
  final String onTapTrueText;
  final Function onTapFalse;
  final String onTapFalseText;
  final bool bigTitle;

  CustomDialog({
    this.isFailed = false,
    this.rotateAngle = 0,
    @required this.icon,
    @required this.title,
    @required this.description,
    @required this.onTapFalse,
    @required this.onTapTrue,
    this.onTapTrueText,
    this.onTapFalseText,
    this.bigTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
            left: 0,
            right: 0,
            top: -55,
            child: Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isFailed
                      ? ColorResources.getRedColor()
                      : Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
              child: Transform.rotate(
                  angle: rotateAngle,
                  child: Icon(icon, size: 40, color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              bigTitle
                  ? FittedBox(
                      child: Text(title,
                          style: notoSerifRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start))
                  : Text(title,
                      style: notoSerifRegular.copyWith(
                          fontSize: bigTitle
                              ? Dimensions.PADDING_SIZE_SMALL
                              : Dimensions.FONT_SIZE_LARGE),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Text(description,
                  textAlign: TextAlign.center, style: notoSerifRegular),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              onTapFalseText != null && onTapFalseText != null
                  ? GetBuilder<AuthController>(builder: (authController) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          children: [
                            Expanded(
                                child: CustomButton(
                                    buttonText: onTapFalseText,
                                    onPressed: onTapFalse)),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: CustomButton(
                              buttonText: onTapTrueText,
                              onPressed: onTapTrue,
                            )),
                          ],
                        ),
                      );
                    })
                  : SizedBox(),
            ]),
          ),
        ]),
      ),
    );
  }
}
