import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sixam_mart/data/api/zopay_api.dart';
import 'package:sixam_mart/data/model/zopay/user_info.dart';

import '../../../../../../../controller/zopay/home_controller.dart';
import '../../../../../../../util/color_resources.dart';
import 'custom_rect_tween.dart';

class QrPopupCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrPopupCardState();
}

class _QrPopupCardState extends State<QrPopupCard> {
  UserInfoZopay userInfoZopay = UserInfoZopay();

  void getUser(ApiZopay apiZopay) async{
    final response = await apiZopay.getUser().get();
    userInfoZopay = response.data();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GetBuilder<ApiZopay>(builder: (ApiZopay apiZopay)  {
      getUser(apiZopay);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
            tag: Get.find<HomeController>().heroShowQr,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin, end: end);
            },
            child: Material(
              color: ColorResources.whiteColor,
              elevation: 2,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: QrImage(
                    data: userInfoZopay.qrCode!=null? userInfoZopay.qrCode:"",
                    version: QrVersions.auto,
                    size: size.width * 0.8,
                    gapless: false,
                  )),
            ),
          ),
        ),
      );
    });
  }
}
