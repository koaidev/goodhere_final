
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/zopay/withdraw_model.dart';
import '../../helper/date_converter.dart';
import '../../helper/price_converter.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class WithdrawWidget extends StatelessWidget {
  final WithdrawModel withdrawModel;
  final bool showDivider;
  WithdrawWidget({@required this.withdrawModel, @required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Row(children: [

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(PriceConverter.convertPrice(withdrawModel.amount), style: robotoMedium),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Text('${'transferred_to'.tr} ${withdrawModel.bankName}', style: robotoRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
            )),

          ])),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

            Text(
              DateConverter.dateTimeStringToDateTime(withdrawModel.requestedAt),
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Text(withdrawModel.status.tr, style: robotoRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_SMALL,
              color: withdrawModel.status == 'Approved' ? Colors.green : withdrawModel.status == 'Denied'
                  ? Colors.red : Theme.of(context).primaryColor,
            )),

          ]),

        ]),
      ),

      Divider(color: showDivider ? Theme.of(context).disabledColor : Colors.transparent),

    ]);
  }
}
