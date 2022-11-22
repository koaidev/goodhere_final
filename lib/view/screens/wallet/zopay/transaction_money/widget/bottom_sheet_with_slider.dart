import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../../../../../controller/zopay/bootom_slider_controller.dart';
import '../../../../../../data/api/zopay_api.dart';
import '../../../../../../data/model/zopay/contact_model.dart';
import '../../../../../../data/model/zopay/response_zopay.dart';
import '../../../../../../data/model/zopay/transaction_zopay.dart';
import '../../../../../../data/model/zopay/user_info.dart';
import '../../../../../../helper/route_helper.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../../../../base/zopay/custom_ink_well.dart';
import '../../../../checkout/checkout_screen.dart';

class BottomSheetWithSlider extends StatefulWidget {
  final int amount;
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
  UserInfoZopay userReceiver;
  TransactionZopay transactionZopay;
  ResponseZopay responseZopay;

  @override
  void initState() {
    super.initState();
  }

  Future<void> pay() async {
    final responsePhone =
        await findUserViaPhone(widget.contactModel.phoneNumber);
    if (responsePhone != null &&
        responsePhone.status == ApiZopay.STATUS_SUCCESS) {
      final responsePay =
          await transferMoneyToOtherZopayWallet((widget.amount), userReceiver);
      setState(() {
        responseZopay = responsePay ?? null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = widget.transactionType == 'send_money'
        ? 'send_money'.tr
        : widget.transactionType == 'cash_out'
            ? 'cash_out'.tr
            : 'request_money'.tr;

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
                      style: robotoBold.copyWith(),
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
              Visibility(
                child: Column(
                  children: [
                    if (responseZopay != null &&
                        responseZopay.status == ApiZopay.STATUS_SUCCESS)
                      Lottie.asset(Images.success_animation,
                          width: Dimensions.SUCCESS_ANIMATION_WIDTH,
                          fit: BoxFit.contain,
                          alignment: Alignment.center),
                    if (responseZopay != null &&
                        responseZopay.status == ApiZopay.STATUS_FAIL)
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: Lottie.asset(Images.failed_animation,
                            width: Dimensions.FAILED_ANIMATION_WIDTH,
                            fit: BoxFit.contain,
                            alignment: Alignment.center),
                      ),
                  ],
                ),
                visible: responseZopay != null,
              ),
              // : AvatarSection(
              // image: widget.transactionType != 'cash_out'
              //     ? customerImage
              //     : agentImage),
              Container(
                color: ColorResources.getBackgroundColor(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    if (responseZopay != null &&
                        responseZopay.status == ApiZopay.STATUS_SUCCESS)
                      Text(
                          widget.transactionType == 'send_money'
                              ? 'send_money_successful'.tr
                              : widget.transactionType == 'request_money'
                                  ? 'request_send_successful'.tr
                                  : 'cash_out_successful'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.getPrimaryTextColor())),
                    // : SizedBox(),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),

                    Text(PriceConverter.convertPrice((widget.amount)),
                        style: robotoMedium.copyWith(fontSize: 34.0)),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('charge'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text(PriceConverter.convertPrice(0),
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

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
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.contactModel.name == null
                                    ? '(unknown )'
                                    : '(${widget.contactModel.name}) ',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(widget.contactModel.phoneNumber,
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          if (responseZopay != null &&
                              responseZopay.status == ApiZopay.STATUS_SUCCESS)
                            Text('TrxID: ${transactionZopay.transactionId}',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // : SizedBox(),
              Visibility(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
                    ),
                    child: CustomInkWell(
                      onTap: () {
                        Get.find<BottomSliderController>().goBackButton();
                      },
                      radius: Dimensions.RADIUS_SIZE_SMALL,
                      highlightColor:
                          ColorResources.getPrimaryTextColor().withOpacity(0.1),
                      child: SizedBox(
                        height: 50.0,
                        child: Center(
                            child: Text(
                          'back_to_home'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                        )),
                      ),
                    ),
                  ),
                ),
                visible: responseZopay != null,
              ),
              Visibility(
                child: ConfirmationSlider(
                  height: 60.0,
                  backgroundColor: ColorResources.getGreyBaseGray6(),
                  text: 'swipe_to_confirm'.tr,
                  textStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.PADDING_SIZE_LARGE),
                  shadow: BoxShadow(),
                  sliderButtonContent: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(Images.slide_right_icon),
                  ),
                  onConfirmation: () async {
                    if (widget.transactionType == "send_money") {
                      pay();
                    } else if (widget.transactionType == "request_money") {
                    } else if (widget.transactionType == "cash_out") {}
                  },
                ),
                visible: responseZopay == null,
              ),
              SizedBox(height: 40.0),
            ],
          )),
    );
  }

  Future<ResponseZopay> findUserViaPhone(String phoneNumber) async {
    final response = await ApiZopay()
        .getUserCollection()
        .where('referral_code', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    if (response.docs.isNotEmpty) {
      userReceiver = UserInfoZopay.fromJson(
          response.docs.first as DocumentSnapshot<Map<String, dynamic>>, null);
      final responseZopay = ResponseZopay(status: ApiZopay.STATUS_SUCCESS);
      return responseZopay;
    } else {
      final responseZopay = ResponseZopay(
          status: ApiZopay.STATUS_FAIL,
          message: "Số điện thoại chưa tham gia Zopay");
      return responseZopay;
    }
  }

  Future<ResponseZopay> transferMoneyToOtherZopayWallet(
    int amount,
    UserInfoZopay receiver,
  ) async {
    final transactionId =
        getRandomString(5) + DateTime.now().microsecondsSinceEpoch.toString();
    final uidReceiver = receiver.uid;

    final transaction = TransactionZopay(
        transactionId: transactionId,
        uidSender: Get.find<ApiZopay>().uid,
        phoneReceiver: receiver.phone,
        nameReceiver: receiver.name,
        uidReceiver: uidReceiver,
        amount: amount,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        typeTransaction: TransactionType.TYPE_TRANSFER);
    final response =
        await Get.find<ApiZopay>().createNewTransaction(transaction);
    if (response.status == ApiZopay.STATUS_SUCCESS) {
      transactionZopay = transaction;
    } else {
      transactionZopay = null;
    }
    return response;
  }
}
