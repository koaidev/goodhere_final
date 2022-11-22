import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/zopay/user_wallet.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../data/api/zopay_api.dart';
import '../../../../../../helper/price_converter.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../transaction_money/transaction_money_screen.dart';
import '../../transaction_money/widget/transaction_money_balance_input.dart';
import 'custom_card.dart';

class FirstCardPortion extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstCardPortionState();
}

class _FirstCardPortionState extends State<FirstCardPortion> {
  UserWallet userWallet;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Get.find<ApiZopay>().getUserWallet(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            userWallet = UserWallet(uid: Get.find<ApiZopay>().uid);
          }
          if (snapshot.hasData) {
            userWallet = snapshot.data.data() ??
                UserWallet(uid: Get.find<ApiZopay>().uid);
          }
          var amountReferral = 0;
          for (var ref in userWallet.listReferral) {
            if (ref.moneyGetNow != null) {
              amountReferral += ref.moneyGetNow;
            }
          }
          return SizedBox(
            child: Stack(
              children: [
                Container(
                  height: Dimensions.MAIN_BACKGROUND_CARD_WEIGHT,
                  color: ColorResources.getBackgroundColor(),
                ),
                Positioned(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        // height: Dimensions.ADD_MONEY_CARD,
                        margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE,
                            vertical: Dimensions.PADDING_SIZE_LARGE),
                        decoration: BoxDecoration(
                            // borderRadius:
                            //     BorderRadius.circular(Dimensions.RADIUS_SIZE_LARGE),
                            // color: Theme.of(context).cardColor,
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Tài Khoản Chính",
                                    style: robotoMedium.copyWith(
                                      color:
                                          ColorResources.getBalanceTextColor(),
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          PriceConverter.convertPrice(
                                              userWallet.pointMain),
                                          style: robotoBold.copyWith(
                                            color:
                                                ColorResources.getBlackColor(),
                                            fontSize:
                                                Dimensions.FONT_SIZE_OVER_LARGE,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Visibility(
                                          visible: true,
                                          child: Text(
                                              "(+ ${PriceConverter.convertPrice(amountReferral)})",
                                              style: robotoRegular.copyWith(
                                                color: Colors.green,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                              ))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                  Visibility(
                                      visible: true,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'TK Khuyến Mại:',
                                            style: robotoRegular.copyWith(
                                              color: ColorResources
                                                  .getBalanceTextColor(),
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                          ),
                                          Text(
                                              "${PriceConverter.convertPrice(userWallet.pointPromotion)}",
                                              style: robotoMedium.copyWith(
                                                color: Colors.black,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            // const Spacer(),
                          ],
                        ),
                      ),

                      /// Cards...
                      SizedBox(
                        height: Dimensions.TRANSACTION_TYPE_CARD_HEIGHT,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomCard(
                                      image: Images.sendMoney_logo,
                                      text: 'send_money_'.tr,
                                      // color: Theme.of(context).secondaryHeaderColor,
                                      onTap: () => Get.to(() =>
                                          TransactionMoneyScreen(
                                              fromEdit: false,
                                              phoneNumber: FirebaseAuth.instance
                                                          .currentUser !=
                                                      null
                                                  ? FirebaseAuth.instance
                                                      .currentUser.phoneNumber
                                                      .replaceAll("+84", "0")
                                                  : "",
                                              transactionType: 'send_money')))),
                              Expanded(
                                  child: CustomCard(
                                      image: Images.cashOut_logo,
                                      text: 'cash_out_'.tr,
                                      // color: ColorResources.getCashOutCardColor(),
                                      onTap: () => Get.to(() =>
                                          TransactionMoneyScreen(
                                              fromEdit: false,
                                              phoneNumber: FirebaseAuth.instance
                                                  .currentUser !=
                                                  null
                                                  ? FirebaseAuth.instance
                                                  .currentUser.phoneNumber
                                                  .replaceAll("+84", "0")
                                                  : "",
                                              transactionType: 'cash_out')))),
                              Expanded(
                                child: CustomCard(
                                    image: Images.request_list_image2,
                                    text: 'add_money'.tr,
                                    // color: ColorResources.getReferFriendCardColor(),
                                    onTap: () => Get.to(
                                        TransactionMoneyBalanceInput(
                                            transactionType: 'add_money'))),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // BannerView(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
