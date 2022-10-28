import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../transaction_money/transaction_money_screen.dart';
import '../../transaction_money/widget/transaction_money_balance_input.dart';
import 'custom_card.dart';

class SecondCardPortion extends StatelessWidget {
  const SecondCardPortion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            height: 75,
            color: ColorResources.getPrimaryColor(),
          ),
          Positioned(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  margin: const EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_LARGE),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          image: Images.sendMoney_logo,
                          text: 'send_money'.tr,
                          color: Theme.of(context).secondaryHeaderColor,
                          onTap: () {
                            Get.to(() => TransactionMoneyScreen(
                                fromEdit: false,
                                transactionType: 'send_money'));
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomCard(
                          image: Images.cashOut_logo,
                          text: 'cash_out'.tr,
                          color: ColorResources.getCashOutCardColor(),
                          onTap: () {
                            Get.to(() => TransactionMoneyScreen(
                                fromEdit: false, transactionType: 'cash_out'));
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomCard(
                          image: Images.wolet_logo,
                          text: 'Add Money'.tr,
                          color: ColorResources.getAddMoneyCardColor(),
                          onTap: () => Get.to(TransactionMoneyBalanceInput(
                              transactionType: 'add_money')),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          image: Images.requestMoney_logo,
                          text: 'request_money'.tr,
                          color: ColorResources.getRequestMoneyCardColor(),
                          onTap: () {
                            Get.to(() => TransactionMoneyScreen(
                                fromEdit: false,
                                transactionType: 'request_money'));
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// Banner..
                // BannerView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
