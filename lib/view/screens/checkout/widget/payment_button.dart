import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButton extends StatelessWidget {
  final String icon;
  final String title;
  String? subtitle;
  final bool isSelected;
  final Function() onTap;

  PaymentButton(
      {required this.isSelected,
      required this.icon,
      required this.title,
      required this.onTap,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                BoxShadow(
                    color:
                        Get.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
            ),
            child: ListTile(
              leading: Image.asset(
                icon,
                width: 40,
                height: 40,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor,
              ),
              title: Text(
                title,
                style:
                    robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              subtitle: subtitle!=null? Text(
                subtitle!,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).disabledColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ) : null,
              trailing: isSelected
                  ? Icon(Icons.check_circle,
                      color: Theme.of(context).primaryColor)
                  : null,
            ),
          ),
        ),
      );
    });
  }
}
