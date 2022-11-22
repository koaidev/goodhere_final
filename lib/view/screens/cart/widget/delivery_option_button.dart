import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final int charge;
  final bool isFree;
  final String typeModule;

  DeliveryOptionButton(
      {@required this.value,
      @required this.title,
      @required this.charge,
      @required this.isFree,
      @required this.typeModule});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return InkWell(
          onTap: () => orderController.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: orderController.orderType,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (String value) =>
                    orderController.setOrderType(value),
                activeColor: Theme.of(context).primaryColor,
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Text(title, style: robotoRegular),
              SizedBox(width: 5),
              Text(
                '${(typeModule == "ecommerce" || typeModule == "grocery") ? "" : '(${(value == 'take_away' || isFree) ? 'free'.tr : charge != -1 ? PriceConverter.convertPrice(charge) : 'calculating'.tr})'}',
                style: robotoMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
