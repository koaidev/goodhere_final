import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';

import '../../../../util/app_constants.dart';
class StoreDescriptionView extends StatefulWidget{
  final Store store;
  StoreDescriptionView({@required this.store});
  @override
  State<StatefulWidget> createState() => _StoreDescriptionViewState();

}
class _StoreDescriptionViewState extends State<StoreDescriptionView> {
  Store store;
  Position newLocalData = Get.find();

  @override
  void initState() {
    super.initState();
    store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    bool _isAvailable = Get.find<StoreController>()
        .isStoreOpenNow(store.active, store.schedules);
    Color _textColor =
        ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    String timeVN;
    if (store.deliveryTime.toString().contains("mins")) {
      timeVN = store.deliveryTime.toString().replaceAll("mins", "phút");
    } else if (store.deliveryTime.toString().contains("min")) {
      timeVN = store.deliveryTime.toString().replaceAll("min", "phút");
    } else if (store.deliveryTime.toString().contains("hours")) {
      timeVN = store.deliveryTime.toString().replaceAll("hours", "giờ");
    } else if (store.deliveryTime.toString().contains("hour")) {
      timeVN = store.deliveryTime.toString().replaceAll("hour", "giờ");
    } else if (store.deliveryTime.toString().contains("days")) {
      timeVN = store.deliveryTime.toString().replaceAll("days", "ngày");
    } else if (store.deliveryTime.toString().contains("day")) {
      timeVN = store.deliveryTime.toString().replaceAll("day", "ngày");
    }
    final distance = Geolocator.distanceBetween(
        newLocalData.latitude,
        newLocalData.longitude,
        double.parse(store.latitude),
        double.parse(store.longitude));

    return Column(children: [
      Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          child: Stack(children: [
            CustomImage(
              image:
                  '${Get.find<SplashController>().configModel.baseUrls.storeImageUrl}/${store.logo}',
              height: ResponsiveHelper.isDesktop(context) ? 80 : 60,
              width: ResponsiveHelper.isDesktop(context) ? 100 : 70,
              fit: BoxFit.cover,
            ),
            _isAvailable
                ? SizedBox()
                : Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(Dimensions.RADIUS_SMALL)),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Text(
                        'closed_now'.tr,
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                  ),
          ]),
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(
              store.name,
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge, color: _textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            InkWell(
              onTap: () =>
                  Get.toNamed(RouteHelper.getSearchStoreItemRoute(store.id)),
              child: ResponsiveHelper.isDesktop(context)
                  ? Container(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                          color: Theme.of(context).primaryColor),
                      child: Center(
                          child: Icon(Icons.search, color: Colors.white)),
                    )
                  : Icon(Icons.search, color: Theme.of(context).primaryColor),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            GetBuilder<WishListController>(builder: (wishController) {
              bool _isWished =
                  wishController.wishStoreIdList.contains(store.id);
              return InkWell(
                onTap: () {
                  if (Get.find<AuthController>().isLoggedIn()) {
                    _isWished
                        ? wishController.removeFromWishList(store.id, true)
                        : wishController.addToWishList(null, store, true);
                  } else {
                    showCustomSnackBar('you_are_not_logged_in'.tr);
                  }
                },
                child: ResponsiveHelper.isDesktop(context)
                    ? Container(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.RADIUS_DEFAULT),
                            color: Theme.of(context).primaryColor),
                        child: Center(
                            child: Icon(
                                _isWished
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white)),
                      )
                    : Icon(
                        _isWished ? Icons.favorite : Icons.favorite_border,
                        color: _isWished
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                      ),
              );
            }),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${(distance / 1000).toStringAsFixed(1)} Km - ",
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).primaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(
                  child: Text(
                store.address ?? "",
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).disabledColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))
            ],
          ),
          SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                  : 0),
          Row(children: [
            Text('minimum_order'.tr,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Theme.of(context).disabledColor,
                )),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              PriceConverter.convertPrice(store.minimumOrder),
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Theme.of(context).primaryColor),
            ),
          ]),
        ])),
      ]),
      SizedBox(
          height: ResponsiveHelper.isDesktop(context)
              ? 30
              : Dimensions.PADDING_SIZE_SMALL),
      Row(children: [
        Expanded(child: SizedBox()),
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getStoreReviewRoute(store.id)),
          child: Column(children: [
            Row(children: [
              Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                store.avgRating.toStringAsFixed(1),
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: _textColor),
              ),
            ]),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              '${store.ratingCount} ${'ratings'.tr}',
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: _textColor),
            ),
          ]),
        ),
        Expanded(child: SizedBox()),
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getMapRoute(
            AddressModel(
              id: store.id,
              address: store.address,
              latitude: store.latitude,
              longitude: store.longitude,
              contactPersonNumber: '',
              contactPersonName: '',
              addressType: '',
            ),
            'store',
          )),
          child: Column(children: [
            Icon(Icons.location_on,
                color: Theme.of(context).primaryColor, size: 20),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text('location'.tr,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: _textColor)),
          ]),
        ),
        Expanded(child: SizedBox()),
        Column(children: [
          Row(children: [
            Icon(Icons.timer, color: Theme.of(context).primaryColor, size: 20),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              (Get.find<SharedPreferences>()
                          .getString(AppConstants.COUNTRY_CODE) !=
                      "VN")
                  ? store.deliveryTime
                  : timeVN ?? store.deliveryTime,
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: _textColor),
            ),
          ]),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text('delivery_time'.tr,
              style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: _textColor)),
        ]),
        (store.delivery && store.freeDelivery)
            ? Expanded(child: SizedBox())
            : SizedBox(),
        (store.delivery && store.freeDelivery)
            ? Column(children: [
                Icon(Icons.money_off,
                    color: Theme.of(context).primaryColor, size: 20),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text('free_delivery'.tr,
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: _textColor)),
              ])
            : SizedBox(),
        Expanded(child: SizedBox()),
      ]),
    ]);
  }
}
