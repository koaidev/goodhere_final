import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/zopay/transaction_zopay.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../helper/date_converter.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';

class TransactionHistoryCardView extends StatelessWidget {
  final TransactionZopay transaction;

  const TransactionHistoryCardView({Key key, this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _userPhone;
    String _userName;
    try {
      _userPhone = "0394998716";
      _userName = "Nguyễn KIm Khánh";
    } catch (e) {
      _userPhone = 'no_user'.tr;
      _userName = 'no_user'.tr;
    }
    String _imageLogo = Images.send_money_image;

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
                        Text('send_money'.tr,
                            style: notoSerifMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                        SizedBox(
                            height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),
                        Text(
                          _userName ?? '',
                          style: notoSerifRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                            height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                        Text(_userPhone ?? '',
                            style: notoSerifMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL)),
                        SizedBox(
                            height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                        Text('TrxID: ${transaction.transactionId}',
                            style: notoSerifRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL))
                        // Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor()),),
                      ]),
                  Spacer(),
                  Text('- 100.000',
                      style: notoSerifMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color:
                          // transaction.transactionType == 'send_money' ||
                          //         transaction.transactionType == 'cash_out'
                          //     ? Colors.redAccent
                               Colors.green)),
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
              DateConverter.localDateToIsoStringAMPM(
                  DateTime.parse("14/03/2022")),
              style: notoSerifRegular.copyWith(
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
