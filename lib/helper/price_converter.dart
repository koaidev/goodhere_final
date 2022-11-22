import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:get/get.dart';

class PriceConverter {
  static String balanceInputHint(){
    String _currencySymbol = Get.find<SplashController>().configModel.currencySymbol;
    String _balance = '0';
    return '$_balance$_currencySymbol';

  }
  static String convertPrice(int price, {int discount, String discountType}) {
    if(discount != null && discountType != null){
      if(discountType == 'amount') {
        price = price - discount;
      }else if(discountType == 'percent') {
        price = int.parse((price - ((discount / 100) * price)).toStringAsFixed(0));
      }
    }
    bool _isRightSide = Get.find<SplashController>().configModel.currencySymbolDirection == 'right';
    return '${_isRightSide ? '' : Get.find<SplashController>().configModel.currencySymbol+' '}'
        '${(price).toStringAsFixed(Get.find<SplashController>().configModel.digitAfterDecimalPoint)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        '${_isRightSide ? ' '+Get.find<SplashController>().configModel.currencySymbol : ''}';
  }

  static int convertWithDiscount(int price, int discount, String discountType) {
    if(discountType == 'amount') {
      price = price - discount;
    }else if(discountType == 'percent') {
      price = int.parse((price - ((discount / 100) * price)).toStringAsFixed(0));
    }
    return price;
  }

  static double calculation(double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if(type == 'amount') {
      calculatedAmount = discount * quantity;
    }else if(type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(String price, String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel.currencySymbol} OFF';
  }

}