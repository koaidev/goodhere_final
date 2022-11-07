import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/show_name.dart';

import '../../../../../../controller/zopay/home_controller.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import 'animated_card/custom_rect_tween.dart';
import 'animated_card/hero_dialogue_route.dart';
import 'animated_card/qr_popup_card.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  AppBarBase({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFCC00),
        // color: ColorResources.blackColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE),
            bottomRight: Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE)),
      ),
      child: Container(
        padding: const EdgeInsets.only(
            top: 16,
            left: Dimensions.PADDING_SIZE_LARGE,
            right: Dimensions.PADDING_SIZE_LARGE,
            bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: ColorResources.blackColor.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE),
              bottomRight: Radius.circular(Dimensions.RADIUS_SIZE_EXTRA_LARGE)),
        ),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  // Get.find<MenuController>().selectProfilePage();
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: Dimensions.RADIUS_SIZE_OVER_LARGE,
                    width: Dimensions.RADIUS_SIZE_OVER_LARGE,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          // FadeInImage.assetNetwork(
                          //         fit: BoxFit.cover,
                          //         image: Images.user,
                          //         placeholder: Images.avatar,
                          //         imageErrorBuilder:
                          //             (context, imageProvider, err) =>
                          //                 Image.asset(Images.avatar))
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    Images.avatar,
                                    fit: BoxFit.cover,
                                  ))),
                    ))),
            const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            ShowName(),
            // : ShowBalance(profileController: profileController),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(HeroDialogRoute(builder: (context) {
                return QrPopupCard();
              })),
              child: Hero(
                tag: Get.find<HomeController>().heroShowQr,
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.FONT_SIZE_DEFAULT),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorResources.whiteColor,
                  ),
                  child: Container(
                      height: Dimensions.PADDING_SIZE_LARGE,
                      width: Dimensions.PADDING_SIZE_LARGE,
                      child: Image.asset(Images.qrCode)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 200);
}
