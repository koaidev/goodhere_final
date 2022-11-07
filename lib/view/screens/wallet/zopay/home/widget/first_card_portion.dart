import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/api/zopay_api.dart';
import 'package:sixam_mart/data/model/zopay/user_wallet.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../helper/route_helper.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../../../../base/zopay/custom_ink_well.dart';
import '../../transaction_money/transaction_money_screen.dart';
import '../../transaction_money/widget/transaction_money_balance_input.dart';
import 'custom_card.dart';

class FirstCardPortion extends StatelessWidget {
  const FirstCardPortion({
    Key key,
  }) : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final UserWallet userWallet = Get.find<UserWallet>();

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
                              'your_balance'.tr,
                              style: notoSerifRegular.copyWith(
                                color: ColorResources.getBalanceTextColor(),
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            ),
                            Text(userWallet.pointMain.toString(),
                                style: notoSerifBlack.copyWith(
                                  color: ColorResources.getBlackColor(),
                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                )),
                            Visibility(
                                visible: true,
                                child: Column(
                                  children: [
                                    Text("+$amountReferralđ",
                                        style: notoSerifMedium.copyWith(
                                          color: Colors.green,
                                          fontSize: Dimensions.fontSizeLarge,
                                        )),
                                  ],
                                )),
                            Visibility(
                                visible: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tài khoản thưởng',
                                      style: notoSerifRegular.copyWith(
                                        color: ColorResources
                                            .getBalanceTextColor(),
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                    ),
                                    Text("${userWallet.pointPromotion}đ",
                                        style: notoSerifMedium.copyWith(
                                          color: Colors.black,
                                          fontSize: Dimensions.fontSizeLarge,
                                        )),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFF039D55),
                        ),
                        child: CustomInkWell(
                          onTap: () =>
                              Get.to(TransactionMoneyBalanceInput(
                                  transactionType: 'add_money')),
                          radius: Dimensions.RADIUS_SIZE_LARGE,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 34,
                                    child: Image.asset(Images.wolet_logo)),
                                SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                Text(
                                  'add_money'.tr,
                                  style: notoSerifRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Cards...
                SizedBox(
                  height: Dimensions.TRANSACTION_TYPE_CARD_HEIGHT,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.FONT_SIZE_EXTRA_SMALL),
                    child: Row(
                      children: [
                        Expanded(
                            child: CustomCard(
                                image: Images.sendMoney_logo,
                                text: 'send_money_'.tr,
                                // color: Theme.of(context).secondaryHeaderColor,
                                onTap: () =>
                                    Get.to(() =>
                                        TransactionMoneyScreen(
                                            fromEdit: false,
                                            transactionType: 'send_money')))),
                        Expanded(
                            child: CustomCard(
                                image: Images.cashOut_logo,
                                text: 'cash_out_'.tr,
                                // color: ColorResources.getCashOutCardColor(),
                                onTap: () =>
                                    Get.to(() =>
                                        TransactionMoneyScreen(
                                            fromEdit: false,
                                            transactionType: 'cash_out')))),
                        // Expanded(
                        //     child: CustomCard(
                        //         image: Images.requestMoneyLogo,
                        //         text: 'request_money'.tr,
                        //         // color:
                        //         //     ColorResources.getRequestMoneyCardColor(),
                        //         onTap: () => Get.to(() =>
                        //             TransactionMoneyScreen(
                        //                 fromEdit: false,
                        //                 transactionType: 'request_money')))),
                        Expanded(
                          child: CustomCard(
                              image: Images.request_list_image2,
                              text: 'requests'.tr,
                              // color: ColorResources.getReferFriendCardColor(),
                              onTap: () =>
                                  Get.toNamed(
                                      RouteHelper.getRequestedMoneyRoute(
                                          from: 'other'))),
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
  }
}
