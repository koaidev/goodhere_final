import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';

class PopularStoreView extends StatefulWidget {
  final bool isPopular;
  final bool isFeatured;

  PopularStoreView({
    @required this.isPopular,
    @required this.isFeatured,
  });

  @override
  State<StatefulWidget> createState() => _PopularStoreViewState();
}

class _PopularStoreViewState extends State<PopularStoreView> {
  Position newLocalData;

  Future<List<Store>> sortList(List<Store> list) async {
    if (await Permission.location.isGranted) {
      newLocalData = Get.find() ?? null;
      list.sort((a, b) => calculateDistance(newLocalData, a)
          .compareTo(calculateDistance(newLocalData, b)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      List<Store> _storeList = widget.isFeatured
          ? storeController.featuredStoreList
          : widget.isPopular
              ? storeController.popularStoreList
              : storeController.latestStoreList;
      sortList(_storeList).then((value) => _storeList);
      return (_storeList != null && _storeList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      10, widget.isPopular ? 2 : 15, 10, 10),
                  child: TitleWidget(
                    title: widget.isFeatured
                        ? 'featured_stores'.tr
                        : widget.isPopular
                            ? Get.find<SplashController>()
                                    .configModel
                                    .moduleConfig
                                    .module
                                    .showRestaurantText
                                ? 'popular_restaurants'.tr
                                : 'popular_stores'.tr
                            : '${'new_on'.tr} ${AppConstants.APP_NAME}',
                    onTap: () => Get.toNamed(
                        RouteHelper.getAllStoreRoute(widget.isFeatured
                            ? 'featured'
                            : widget.isPopular
                                ? 'popular'
                                : 'latest')),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: _storeList != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount:
                              _storeList.length > 10 ? 10 : _storeList.length,
                          itemBuilder: (context, index) {
                            final distance = newLocalData != null
                                ? Geolocator.distanceBetween(
                                    newLocalData.latitude,
                                    newLocalData.longitude,
                                    double.parse(_storeList[index].latitude),
                                    double.parse(_storeList[index].longitude))
                                : null;
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL,
                                  bottom: 5),
                              child: InkWell(
                                onTap: () {
                                  if (widget.isFeatured &&
                                      Get.find<SplashController>().moduleList !=
                                          null) {
                                    for (ModuleModel module
                                        in Get.find<SplashController>()
                                            .moduleList) {
                                      if (module.id ==
                                          _storeList[index].moduleId) {
                                        Get.find<SplashController>()
                                            .setModule(module);
                                        break;
                                      }
                                    }
                                  }
                                  Get.toNamed(
                                    RouteHelper.getStoreRoute(
                                        _storeList[index].id,
                                        widget.isFeatured ? 'module' : 'store'),
                                    arguments: StoreScreen(
                                        store: _storeList[index],
                                        fromModule: widget.isFeatured),
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[
                                            Get.find<ThemeController>()
                                                    .darkTheme
                                                ? 800
                                                : 300],
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(
                                                    Dimensions.RADIUS_SMALL)),
                                            child: CustomImage(
                                              image:
                                                  '${Get.find<SplashController>().configModel.baseUrls.storeCoverPhotoUrl}'
                                                  '/${_storeList[index].coverPhoto}',
                                              height: 90,
                                              width: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          DiscountTag(
                                            discount: storeController
                                                .getDiscount(_storeList[index]),
                                            discountType:
                                                storeController.getDiscountType(
                                                    _storeList[index]),
                                            freeDelivery:
                                                _storeList[index].freeDelivery,
                                          ),
                                          storeController
                                                  .isOpenNow(_storeList[index])
                                              ? SizedBox()
                                              : NotAvailableWidget(
                                                  isStore: true),
                                          Positioned(
                                            top: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                            right: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                            child:
                                                GetBuilder<WishListController>(
                                                    builder: (wishController) {
                                              bool _isWished = wishController
                                                  .wishStoreIdList
                                                  .contains(
                                                      _storeList[index].id);
                                              return InkWell(
                                                onTap: () {
                                                  if (Get.find<AuthController>()
                                                      .isLoggedIn()) {
                                                    _isWished
                                                        ? wishController
                                                            .removeFromWishList(
                                                                _storeList[
                                                                        index]
                                                                    .id,
                                                                true)
                                                        : wishController
                                                            .addToWishList(
                                                                null,
                                                                _storeList[
                                                                    index],
                                                                true);
                                                  } else {
                                                    showCustomSnackBar(
                                                        'you_are_not_logged_in'
                                                            .tr);
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .RADIUS_SMALL),
                                                  ),
                                                  child: Icon(
                                                    _isWished
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    size: 15,
                                                    color: _isWished
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Theme.of(context)
                                                            .disabledColor,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ]),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _storeList[index].name ??
                                                        '',
                                                    style:
                                                        robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      if (distance != null)
                                                        Text(
                                                          "${(distance / 1000).toStringAsFixed(1)} Km - ",
                                                          style: robotoMedium.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      Expanded(
                                                          child: Text(
                                                        _storeList[index]
                                                                .address ??
                                                            "",
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeExtraSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ))
                                                    ],
                                                  ),
                                                  RatingBar(
                                                    rating: _storeList[index]
                                                        .avgRating,
                                                    ratingCount:
                                                        _storeList[index]
                                                            .ratingCount,
                                                    size: 12,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          },
                        )
                      : PopularStoreShimmer(storeController: storeController),
                ),
              ],
            );
    });
  }

  double calculateDistance(Position position, Store store) {
    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        double.parse(store.latitude),
        double.parse(store.longitude));
    return distanceInMeters;
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final StoreController storeController;

  PopularStoreShimmer({@required this.storeController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 150,
          width: 200,
          margin:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)
              ]),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[300]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 10, width: 100, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        Container(
                            height: 10, width: 130, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
