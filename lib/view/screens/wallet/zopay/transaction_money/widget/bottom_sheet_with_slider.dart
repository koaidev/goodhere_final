import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../../../../../data/model/zopay/contact_model.dart';
import '../../../../../../helper/route_helper.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../../../../base/zopay/custom_ink_well.dart';
import 'avator_section.dart';

class BottomSheetWithSlider extends StatefulWidget {
  final String amount;
  final int amountCharge;
  final String pinCode;
  final String transactionType;
  final String purpose;
  final ContactModel contactModel;

  const BottomSheetWithSlider(
      {Key key,
      @required this.amount,
      @required this.amountCharge,
      this.pinCode,
      this.transactionType,
      this.purpose,
      this.contactModel})
      : super(key: key);

  @override
  State<BottomSheetWithSlider> createState() => _BottomSheetWithSliderState();
}

class _BottomSheetWithSliderState extends State<BottomSheetWithSlider> {
  String transactionId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String type = widget.transactionType == 'send_money'
        ? 'send_money'.tr
        : widget.transactionType == 'cash_out'
            ? 'cash_out'.tr
            : 'request_money'.tr;
    // double cashOutCharge = double.parse(widget.amount.toString()) *
    //     (double.parse(Get
    //         .find<SplashController>()
    //         .configModel
    //         .cashOutChargePercent
    //         .toString()) /
    //         100);
    String customerImage = Images.avatar;
    String agentImage = Images.logo;
    return WillPopScope(
      onWillPop: () => Get.offAllNamed(RouteHelper.getNavBarRoute()),
      child: Container(
          decoration: BoxDecoration(
            color: ColorResources.getBackgroundColor(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.RADIUS_SIZE_LARGE),
                topRight: Radius.circular(Dimensions.RADIUS_SIZE_LARGE)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_LARGE),
                    decoration: BoxDecoration(
                      color: ColorResources.getLightGray().withOpacity(0.8),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Dimensions.RADIUS_SIZE_LARGE)),
                    ),
                    child: Text(
                      'confirm_to'.tr + ' ' + type,
                      style: notoSerifBold.copyWith(),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Positioned(
                      top: Dimensions.PADDING_SIZE_SMALL,
                      right: 8.0,
                      child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorResources.getGreyBaseGray6()),
                              child: Icon(
                                Icons.clear,
                                size: Dimensions.PADDING_SIZE_DEFAULT,
                              ))),
                    ),
                  )
                  // : SizedBox(),
                ],
              ),
              Column(
                children: [
                  Lottie.asset(Images.success_animation,
                      width: Dimensions.SUCCESS_ANIMATION_WIDTH,
                      fit: BoxFit.contain,
                      alignment: Alignment.center)
                  //     : Padding(
                  //   padding: const EdgeInsets.all(
                  //       Dimensions.PADDING_SIZE_SMALL),
                  //   child: Lottie.asset(Images.failed_animation,
                  //       width: Dimensions.FAILED_ANIMATION_WIDTH,
                  //       fit: BoxFit.contain,
                  //       alignment: Alignment.center),
                  // ),
                ],
              ),
              // : AvatarSection(
              // image: widget.transactionType != 'cash_out'
              //     ? customerImage
              //     : agentImage),
              Container(
                color: ColorResources.getBackgroundColor(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('charge'.tr,
                            style: notoSerifMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text("49.000",
                            style: notoSerifMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ],
                    ),
                    Text(
                        widget.transactionType == 'send_money'
                            ? 'send_money_successful'.tr
                            : widget.transactionType == 'request_money'
                                ? 'request_send_successful'.tr
                                : 'cash_out_successful'.tr,
                        style: notoSerifMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: ColorResources.getPrimaryTextColor())),
                    // : SizedBox(),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),
                    Text('100.000',
                        style: notoSerifMedium.copyWith(fontSize: 34.0)),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                    Text('new_balance'.tr + ' ' + '100.000',
                        style: notoSerifRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Divider(height: Dimensions.DIVIDER_SIZE_SMALL)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT,
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(
                        children: [
                          Text(
                              widget.transactionType != "cash_out"
                                  ? widget.purpose
                                  : 'cash_out'.tr,
                              style: notoSerifRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.contactModel.name == null
                                    ? '(unknown )'
                                    : '(${widget.contactModel.name}) ',
                                style: notoSerifRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(widget.contactModel.phoneNumber,
                                  style: notoSerifBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Text('TrxID: $transactionId',
                              style: notoSerifRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT / 1.7),
                    child: Divider(height: Dimensions.DIVIDER_SIZE_SMALL),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                  CustomInkWell(
                      onTap: () {},
                      child: Text('share_statement'.tr,
                          style: notoSerifMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE))),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                ],
              ),
              // : SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
                  ),
                  child: CustomInkWell(
                    onTap: () {},
                    radius: Dimensions.RADIUS_SIZE_SMALL,
                    highlightColor:
                        ColorResources.getPrimaryTextColor().withOpacity(0.1),
                    child: SizedBox(
                      height: 50.0,
                      child: Center(
                          child: Text(
                        'back_to_home'.tr,
                        style: notoSerifMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                      )),
                    ),
                  ),
                ),
              ),
              Center(
                  child: CircularProgressIndicator(
                color: ColorResources.getPrimaryTextColor(),
              ))
              //     : ConfirmationSlider(
              //   height: 60.0,
              //   backgroundColor: ColorResources.getGreyBaseGray6(),
              //   text: 'swipe_to_confirm'.tr,
              //   textStyle: notoSerifRegular.copyWith(
              //       fontSize: Dimensions.PADDING_SIZE_LARGE),
              //   shadow: BoxShadow(),
              //   sliderButtonContent: Container(
              //     padding:
              //     EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              //     decoration: BoxDecoration(
              //       color: Theme
              //           .of(context)
              //           .secondaryHeaderColor,
              //       shape: BoxShape.circle,
              //     ),
              //     child: Image.asset(Images.slide_right_icon),
              //   ),
              //   onConfirmation: () async {
              //     if (widget.transactionType == "send_money") {
              //
              //     } else if (widget.transactionType ==
              //         "request_money") {
              //
              //     } else if (widget.transactionType == "cash_out") {
              //       transactionMoneyController
              //           .cashOutMoney(
              //           contactModel: widget.contactModel,
              //           amount: double.parse(widget.amount),
              //           pinCode: widget.pinCode)
              //           .then((value) {
              //         transactionId = value.body['transaction_id'];
              //       });
              //     }
              //   },
              // ),
              // SizedBox(height: 40.0),
            ],
          )),
    );
  }
}
