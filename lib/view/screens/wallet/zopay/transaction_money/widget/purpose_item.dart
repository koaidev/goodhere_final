import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../../../../base/zopay/custom_ink_well.dart';

class PurposeItem extends StatelessWidget {
  const PurposeItem(
      {Key key,
      @required this.image,
      @required this.title,
      @required this.color,
      @required this.onTap})
      : super(key: key);
  final String image;
  final String title;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.0, bottom: 20, top: 10),
      height: 120,
      width: 95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 20.0,
                color: ColorResources.blackColor.withOpacity(0.05),
                spreadRadius: 0.0,
                offset: Offset(0.0, 4.0)),
          ]),
      child: CustomInkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.RADIUS_SIZE_VERY_SMALL),
                    topRight:
                        Radius.circular(Dimensions.RADIUS_SIZE_VERY_SMALL),
                  ),
                ),
                child: Center(
                    child: Padding(
                        //height: 36,width: 36,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                        child: FadeInImage.assetNetwork(
                            imageErrorBuilder: (c, o, x) =>
                                Image.asset(Images.placeholder),
                            placeholder: Images.placeholder,
                            image: Images.logo,
                            fit: BoxFit.cover))
                    // ),
                    ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: notoSerifRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: ColorResources.getGreyColor()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
