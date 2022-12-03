import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/show_amount_view.dart';

import '../../../../../../controller/zopay/bootom_slider_controller.dart';
import '../../../../../../data/api/zopay_api.dart';
import '../../../../../../data/model/zopay/contact_model.dart';
import '../../../../../../data/model/zopay/user_info.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../base/demo_otp_hint.dart';
import '../../../../../base/zopay/custom_app_bar.dart';
import 'bottom_sheet_with_slider.dart';
import 'for_person_widget.dart';

class TransactionMoneyConfirmation extends StatelessWidget {
  final double inputBalance;
  final String transactionType;
  final String purpose;
  final ContactModel contactModel;
  final int feePercent;
  final String idReceiver;

  TransactionMoneyConfirmation(
      {@required this.inputBalance,
      @required this.transactionType,
      this.purpose,
      this.contactModel,
      this.feePercent = 0,
      @required this.idReceiver});

  final _pinCodeFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          title: transactionType == 'send_money'
              ? 'send_money'.tr
              : transactionType == 'cash_out'
                  ? 'cash_out'.tr
                  : 'request_money'.tr,
          onTap: () {
            Get.back();
          },
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: Get.find<ApiZopay>().getUserStream(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            final UserInfoZopay userInfoZopay = snapshot.data.data() ??
                UserInfoZopay(uid: Get.find<ApiZopay>().uid);
            bool isValidPin = false;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ForPersonWidget(
                    contactModel: contactModel,
                  ),
                  ShowAmountView(
                      amountText: PriceConverter.convertPrice(
                        inputBalance.toInt(),
                      ),
                      onTap: () => Get.back()),
                  Divider(
                      height: Dimensions.DIVIDER_SIZE_MEDIUM,
                      color: ColorResources.backgroundColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE,
                                bottom: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Text('4digit_pin'.tr,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27.0),
                                    color: ColorResources.getGreyBaseGray6()),
                                child: PinCodeTextField(
                                  controller: _pinCodeFieldController,
                                  length: 4,
                                  appContext: context,
                                  onChanged: (value) {
                                    if (value.length == 4) {
                                      var key = utf8.encode(userInfoZopay.uid);
                                      var bytes = utf8.encode(value);

                                      var hmacSha256 =
                                          Hmac(sha256, key); // HMAC-SHA256
                                      var digest = hmacSha256.convert(bytes);
                                      print("Pin: $digest");
                                      print("Pin server: ${userInfoZopay.pin}");
                                      if (digest.toString() ==
                                          userInfoZopay.pin) {
                                        isValidPin = true;
                                      } else {
                                        isValidPin = false;
                                        showCustomSnackBar(
                                            "Vui lòng nhập đúng mã pin.");
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  obscureText: true,
                                  hintCharacter: '•',
                                  hintStyle: robotoMedium.copyWith(
                                      color: ColorResources.getGreyBaseGray4()),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  cursorColor:
                                      ColorResources.getGreyBaseGray6(),
                                  pinTheme: PinTheme.defaults(
                                      shape: PinCodeFieldShape.circle,
                                      activeColor:
                                          ColorResources.getGreyBaseGray6(),
                                      activeFillColor: Colors.red,
                                      selectedColor:
                                          ColorResources.getGreyBaseGray6(),
                                      borderWidth: 0,
                                      inactiveColor:
                                          ColorResources.getGreyBaseGray6()),
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                            GestureDetector(
                                onTap: () async {
                                  if (isValidPin) {
                                    _pinCodeFieldController.clear();
                                    isValidPin = false;
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: Get.context,
                                        isDismissible: false,
                                        enableDrag: false,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(Dimensions
                                                    .RADIUS_SIZE_LARGE))),
                                        builder: (context) {
                                          return BottomSheetWithSlider(
                                            feePercent: feePercent,
                                            amount: inputBalance.toInt(),
                                            contactModel: contactModel,
                                            pinCode: Get.find<
                                                    BottomSliderController>()
                                                .pin,
                                            transactionType: transactionType,
                                            purpose: purpose,
                                            userInfoZopay: userInfoZopay,
                                            idReceiver: idReceiver,
                                          );
                                        });
                                  } else {
                                    showCustomSnackBar(
                                        "Vui lòng nhập đúng mã PIN",
                                        isError: true);
                                  }
                                },
                                child: Container(
                                    width: Dimensions.RADIUS_SIZE_OVER_LARGE,
                                    height: Dimensions.RADIUS_SIZE_OVER_LARGE,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    child: Icon(Icons.arrow_forward,
                                        color: ColorResources.blackColor))),
                          ],
                        ),
                        if (!isValidPin) DemoOtpHint(),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
