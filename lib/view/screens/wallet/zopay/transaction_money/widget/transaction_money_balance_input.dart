import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/zopay/user_wallet.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/purpose_widget.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/transaction_money_confirmation.dart';

import '../../../../../../controller/localization_controller.dart';
import '../../../../../../controller/splash_controller.dart';
import '../../../../../../controller/zopay/purpose_models.dart';
import '../../../../../../data/api/zopay_api.dart';
import '../../../../../../data/model/zopay/contact_model.dart';
import '../../../../../../helper/price_converter.dart';
import '../../../../../../util/app_constants.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../../../../base/custom_image.dart';
import '../../../../../base/custom_snackbar.dart';
import '../../../../../base/zopay/custom_app_bar.dart';
import 'for_person_widget.dart';
import 'next_button.dart';

class TransactionMoneyBalanceInput extends StatefulWidget {
  final String transactionType;
  final ContactModel contactModel;

  TransactionMoneyBalanceInput(
      {Key key, this.transactionType, this.contactModel})
      : super(key: key);

  @override
  State<TransactionMoneyBalanceInput> createState() =>
      _TransactionMoneyBalanceInputState();
}

class _TransactionMoneyBalanceInputState
    extends State<TransactionMoneyBalanceInput> {
  final TextEditingController _inputAmountController = TextEditingController();
  UserWallet userWallet;
  double amount = 0.0;

  @override
  Widget build(BuildContext context) {
    final LocalizationController localizationController =
        Get.find<LocalizationController>();
    final SplashController splashController = Get.find<SplashController>();

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: CustomAppbar(
              title: widget.transactionType == 'send_money'
                  ? 'send_money'.tr
                  : widget.transactionType == 'cash_out'
                      ? 'cash_out'.tr
                      : widget.transactionType == 'request_money'
                          ? 'request_money'.tr
                          : 'add_money'.tr),
          body: StreamBuilder<DocumentSnapshot>(
              stream: Get.find<ApiZopay>().getUserWallet(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  userWallet = UserWallet(uid: Get.find<ApiZopay>().uid);
                }
                if (snapshot.hasData) {
                  userWallet = snapshot.data.data() ??
                      UserWallet(uid: Get.find<ApiZopay>().uid);
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.transactionType != 'add_money'
                          ? ForPersonWidget(contactModel: widget.contactModel)
                          : SizedBox.shrink(),
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                color: ColorResources.getWhiteAndBlack(),
                                child: Column(
                                  children: [
                                    Container(
                                      width: size.width * 0.6,
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      child: TextField(
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(
                                              AppConstants.BALANCE_INPUT_LEN +
                                                  (AppConstants
                                                              .BALANCE_INPUT_LEN /
                                                          3)
                                                      .floor()),
                                          CurrencyTextInputFormatter(
                                            locale: 'vi',
                                            decimalDigits: 0,
                                            symbol: '\đ',
                                          ),
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        controller: _inputAmountController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        style: robotoMedium.copyWith(
                                            fontSize: 34,
                                            color: ColorResources
                                                .getPrimaryTextColor()),
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          hintText:
                                              '${PriceConverter.balanceInputHint()}',
                                          border: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(),
                                          hintStyle: robotoMedium.copyWith(
                                              fontSize: 34,
                                              color: ColorResources
                                                      .getPrimaryTextColor()
                                                  .withOpacity(0.7)),
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            String balance = _inputAmountController.text;
                                            print('Balance origin: $balance - $amount');

                                            if (balance.contains(
                                                '\đ')) {
                                              balance = balance.replaceAll(
                                                  '\đ', '');
                                            }
                                            print('Balance 2: $balance - $amount');
                                            if (balance.contains('.')) {
                                              balance = balance.replaceAll('.', '');
                                            }
                                            print('Balance 3: $balance - $amount');
                                            if (balance.contains(' ')) {
                                              balance = balance.replaceAll(' ', '');
                                            }
                                            amount = double.parse(balance);
                                            print('Balance final: $balance - $amount');
                                            if (amount > userWallet.pointMain) {
                                              showCustomSnackBar('Số dư hiện tại không khả dụng.',
                                                  isError: true);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    Center(
                                        child: Text(
                                            '${'available_balance'.tr} ${userWallet.pointMain}',
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE,
                                                color: ColorResources
                                                    .getGreyColor()))),
                                    SizedBox(
                                      height: Dimensions.PADDING_SIZE_DEFAULT,
                                    ),
                                  ],
                                ),
                              ),
                              widget.transactionType != 'cash_out' &&
                                      widget.transactionType != 'add_money'
                                  ? localizationController.isLtr
                                      ? Positioned(
                                          left: Dimensions.PADDING_SIZE_LARGE,
                                          bottom: Dimensions
                                              .PADDING_SIZE_EXTRA_LARGE,
                                          child: CustomImage(
                                              image: Images.avatar,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover),
                                        )
                                      : Positioned(
                                          right: Dimensions.PADDING_SIZE_LARGE,
                                          bottom: Dimensions
                                              .PADDING_SIZE_EXTRA_LARGE,
                                          child: CustomImage(
                                              image: Images.avatar,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover),
                                        )
                                  : SizedBox(),
                              widget.transactionType != 'cash_out' &&
                                      widget.transactionType != 'add_money'
                                  ? localizationController.isLtr
                                      ? Positioned(
                                          right: 10,
                                          bottom: 5,
                                          child: Image.asset(
                                              Images.input_stack_desing,
                                              width: 150.0))
                                      : Positioned(
                                          left: 10,
                                          bottom: 5,
                                          child: Transform(
                                              transform:
                                                  Matrix4.rotationY(math.pi),
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  Images.input_stack_desing,
                                                  width: 150.0)))
                                  : SizedBox(),
                            ],
                          ),
                          Container(
                            height: Dimensions.DIVIDER_SIZE_MEDIUM,
                            color: ColorResources.backgroundColor,
                          ),
                        ],
                      ),
                      widget.transactionType != 'add_money'
                          ? widget.transactionType == 'cash_out'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.PADDING_SIZE_LARGE,
                                      vertical:
                                          Dimensions.PADDING_SIZE_DEFAULT),
                                  child: Row(
                                    children: [
                                      Text('save_future_cash_out'.tr,
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)),
                                      Spacer(),
                                      Padding(
                                          padding: EdgeInsets.zero,
                                          child: CupertinoSwitch(
                                            value: true,
                                          ))
                                    ],
                                  ),
                                )
                              : SizedBox()
                          : SizedBox(),
                      widget.transactionType != 'cash_out' &&
                              widget.transactionType != 'add_money'
                          // &&
                          //     Get.find<TransactionMoneyController>()
                          //         .purposeList
                          //         .isNotEmpty
                          ? MediaQuery.of(context).viewInsets.bottom > 10
                              ? Container(
                                  color: ColorResources.whiteColor
                                      .withOpacity(0.92),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.PADDING_SIZE_LARGE,
                                      vertical: Dimensions.PADDING_SIZE_SMALL),
                                  child: Row(
                                    children: [
                                      // GetBuilder<TransactionMoneyController>(
                                      //     builder: (controller) {
                                      //   if (controller.purposeList.isEmpty) {
                                      //     return Center(
                                      //         child: CircularProgressIndicator(
                                      //             color: ColorResources
                                      //                 .getPrimaryTextColor()));
                                      //   }
                                      //   return SizedBox();
                                      // }),
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        'change_purpose'.tr,
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE),
                                      )
                                    ],
                                  ),
                                )
                              : PurposeWidget()
                          : SizedBox(),
                    ],
                  ),
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_inputAmountController.text.isEmpty) {
                showCustomSnackBar('please_input_amount'.tr, isError: true);
              } else {
                String balance = _inputAmountController.text;
                print('Balance origin: $balance - $amount');

                if (balance.contains(
                    '\đ')) {
                  balance = balance.replaceAll(
                      '\đ', '');
                }
                print('Balance 2: $balance - $amount');
                if (balance.contains('.')) {
                  balance = balance.replaceAll('.', '');
                }
                print('Balance 3: $balance - $amount');
                if (balance.contains(' ')) {
                  balance = balance.replaceAll(' ', '');
                }
                amount = double.parse(balance);
                print('Balance final: $balance - $amount');
                if (amount == 0) {
                  showCustomSnackBar('transaction_amount_must_be'.tr,
                      isError: true);
                } else {
                  if ((widget.transactionType == 'send_money' &&
                          amount > userWallet.pointMain) ||
                      (widget.transactionType == 'cash_out' &&
                          amount > userWallet.pointMain)) {
                    showCustomSnackBar('insufficient_balance'.tr,
                        isError: true);
                  } else {
                    // if (widget.transactionType == 'add_money') {
                    //   //todo handle add money
                    //   // Get.find<AddMoneyController>()
                    //   //     .addMoney(context, amount.toString());
                    // } else {
                      Get.to(() => TransactionMoneyConfirmation(
                            inputBalance: amount,
                            transactionType: widget.transactionType,
                            purpose: Purpose().title,
                            contactModel: widget.contactModel,
                          ));
                    // }
                  }
                }
              }
              // }
            },
            child: NextButton(isSubmittable: true),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          )),
    );
  }
}
