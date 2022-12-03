import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/price_converter.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';


class WalletWidget extends StatelessWidget {
  final String title;
  final double value;

  WalletWidget({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_LARGE,
          horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[Get.isDarkMode ? 700 : 300],
              spreadRadius: 0.5,
              blurRadius: 5)
        ],
      ),
      alignment: Alignment.center,
      child: Column(children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_SMALL,
              color: Theme.of(context).disabledColor),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Text(
          PriceConverter.convertPrice(value.toInt()),
          style: robotoBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).primaryColor),
        ),
      ]),
    ));
  }
}
