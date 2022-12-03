import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/zopay/transaction_zopay.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../helper/date_converter.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';

class TransactionHistoryCardView extends StatelessWidget {
  final TransactionZopay transaction;

  const TransactionHistoryCardView({Key key, @required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _imageLogo = transaction.typeTransaction.contains("send_money")
        ? Images.send_money_image
        : transaction.typeTransaction.contains("add_money")
            ? Images.request_list_image2
            : transaction.typeTransaction.contains("cash_out")
                ? Images.cashOut_logo
                : Images.send_money_image;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(_imageLogo))),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            transaction.typeTransaction.contains("add_money")
                                ? 'add_money'.tr
                                : transaction.typeTransaction
                                        .contains("send_money")
                                    ? 'send_money'.tr
                                    : transaction.typeTransaction
                                            .contains("cash_out")
                                        ? 'cash_out'.tr
                                        : 'send_money'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                        SizedBox(
                            height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),
                        Text(
                          transaction.nameReceiver ?? '',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                            height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                        Text(transaction.phoneReceiver ?? '',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL)),
                        SizedBox(
                            height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                        Text(
                            'TrxID: ${transaction != null ? transaction.transactionId : ""}',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL))
                        // Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor()),),
                      ]),
                  Spacer(),
                  Text(PriceConverter.convertPrice(transaction.amount),
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: Colors.green)),
                ],
              ),
              SizedBox(height: 5),
              Divider(height: .125, color: ColorResources.getGreyColor()),
            ],
          ),
          Positioned(
            bottom: 3,
            right: 2,
            child: Text(
              DateConverter.localDateToIsoStringAMPM(DateTime.now()),
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  color: ColorResources.getHintColor()),
            ),
          ),
          // Positioned(
          //   bottom: 3,
          //   left: 2,
          //   child: Text(
          //     DateConverter.localDateToIsoStringAMPM(
          //         DateTime.parse(transactions.createdAt)),
          //     style: notoSerifRegular.copyWith(
          //         fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
          //         color: ColorResources.getHintColor()),
          //   ),
          // )
        ],
      ),
    );
  }
}
