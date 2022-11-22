import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/scan_button.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/transaction_money_balance_input.dart';

import '../../../../../data/api/zopay_api.dart';
import '../../../../../data/model/zopay/contact_model.dart';
import '../../../../../data/model/zopay/response_zopay.dart';
import '../../../../../data/model/zopay/transaction_zopay.dart';
import '../../../../../data/model/zopay/user_info.dart';
import '../../../../../util/color_resources.dart';
import '../../../../../util/dimensions.dart';
import '../../../../../util/images.dart';
import '../../../../base/custom_snackbar.dart';
import '../../../../base/zopay/custom_app_bar.dart';
import '../../../../base/zopay/custom_ink_well.dart';
import '../../../checkout/checkout_screen.dart';
import '../selfie_capture/camera_screen.dart';

class TransactionMoneyScreen extends StatefulWidget {
  final bool fromEdit;
  final String phoneNumber;
  final String transactionType;

  TransactionMoneyScreen(
      {Key key, this.fromEdit, this.phoneNumber, this.transactionType})
      : super(key: key);

  @override
  State<TransactionMoneyScreen> createState() => _TransactionMoneyScreenState();
}

class _TransactionMoneyScreenState extends State<TransactionMoneyScreen> {
  ScrollController _scrollController = ScrollController();
  ContactModel userReceiver;
  ResponseZopay responseZopay;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    widget.fromEdit ? _searchController.text = widget.phoneNumber : SizedBox();

    return Scaffold(
      appBar: CustomAppbar(
          title: widget.transactionType == "send_money"
              ? 'send_money'.tr
              : widget.transactionType == 'cash_out'
                  ? 'cash_out'.tr
                  : 'request_money'.tr),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: SliverDelegate(
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    color: ColorResources.getGreyBaseGray3(),
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                              controller: _searchController,
                              onChanged: (inputText) async {
                                if (inputText.isNotEmpty) {
                                  var _isValid = false;
                                  try {
                                    PhoneNumber phoneNumber =
                                        await PhoneNumberUtil()
                                            .parse("+84$inputText");
                                    _isValid = true;
                                  } catch (e) {}
                                  if (_isValid && inputText!=widget.phoneNumber) {
                                    await findUserViaPhone(inputText);
                                    setState(() {});
                                  }else{

                                  }
                                }
                              },
                              keyboardType: widget.transactionType == 'cash_out'
                                  ? TextInputType.phone
                                  : TextInputType.name,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    top: Dimensions.PADDING_SIZE_DEFAULT),
                                hintText: 'Nhập số điện thoại người nhận',
                                hintStyle: robotoRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: ColorResources.getGreyBaseGray1()),
                              ))),
                      Icon(Icons.search,
                          color: ColorResources.getGreyBaseGray1()),
                    ]),
                  ),
                  Divider(
                      height: Dimensions.DIVIDER_SIZE_SMALL,
                      color: ColorResources.BACKGROUND_COLOR),
                  Container(
                    color: ColorResources.getWhiteColor(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_LARGE,
                          vertical: Dimensions.PADDING_SIZE_SMALL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ScanButton(
                              onTap: () => Get.to(() => CameraScreen(
                                    fromEditProfile: false,
                                    isBarCodeScan: true,
                                    transactionType: widget.transactionType,
                                  ))),
                          InkWell(
                              onTap: () {
                                if (_searchController.text.isEmpty) {
                                  showCustomSnackBar('input_field_is_empty'.tr,
                                      isError: true);
                                } else {
                                  if (widget.transactionType == "cash_out") {
                                    Get.to(() => TransactionMoneyBalanceInput(
                                        transactionType: widget.transactionType,
                                        contactModel: ContactModel(
                                            phoneNumber:
                                                userReceiver.phoneNumber,
                                            name: userReceiver.name,
                                            avatarImage: userReceiver.avatarImage)));
                                  } else {
                                    Get.to(() => TransactionMoneyBalanceInput(
                                        transactionType: widget.transactionType,
                                        contactModel: ContactModel(
                                            phoneNumber:
                                                userReceiver.phoneNumber,
                                            name: userReceiver.name,
                                            avatarImage: userReceiver.avatarImage)));
                                  }
                                }
                              },
                              child: Container(
                                  width: Dimensions.RADIUS_SIZE_OVER_LARGE,
                                  height: Dimensions.RADIUS_SIZE_OVER_LARGE,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green),
                                  child: Icon(Icons.arrow_forward,
                                      color: ColorResources.whiteColor))),
                        ],
                      ),
                    ),
                  )
                ],
              ))),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_SMALL,
                      horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.PADDING_SIZE_SMALL),
                        child: Text('suggested'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),
                      Container(
                        height: 80.0,
                        child: ListView.builder(
                            itemCount: userReceiver != null ? 1 : 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => CustomInkWell(
                                  radius: Dimensions.RADIUS_SIZE_VERY_SMALL,
                                  highlightColor:
                                      ColorResources.getPrimaryTextColor()
                                          .withOpacity(0.3),
                                  onTap: () {
                                    Get.to(() => TransactionMoneyBalanceInput(transactionType: widget.transactionType,
                                        contactModel: ContactModel(
                                            phoneNumber: userReceiver.phoneNumber,
                                            name: userReceiver.name,
                                            avatarImage: userReceiver.avatarImage))
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: Dimensions
                                              .RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                          width: Dimensions
                                              .RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                          child: ClipRRect(
                                            child: Image.asset(
                                              Images.avatar,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions
                                                    .RADIUS_SIZE_OVER_LARGE),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Text(
                                              userReceiver != null
                                                  ? "${userReceiver.name} - ${userReceiver.phoneNumber}"
                                                  : "",
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL)),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ],
                  ),
                )
                // ((transactionMoneyController
                //            .requestMoneySuggestList.isNotEmpty) &&
                //        widget.transactionType == 'request_money')
                //    ? GetBuilder<TransactionMoneyController>(
                //        builder: (requestMoneyController) {
                //        return requestMoneyController.isLoading
                //            ? Center(child: CircularProgressIndicator())
                //            : Padding(
                //                padding: const EdgeInsets.symmetric(
                //                    vertical: Dimensions.PADDING_SIZE_SMALL,
                //                    horizontal:
                //                        Dimensions.PADDING_SIZE_LARGE),
                //                child: Column(
                //                  mainAxisAlignment:
                //                      MainAxisAlignment.start,
                //                  crossAxisAlignment:
                //                      CrossAxisAlignment.start,
                //                  children: [
                //                    Padding(
                //                      padding: const EdgeInsets.only(
                //                          bottom: Dimensions
                //                              .PADDING_SIZE_SMALL),
                //                      child: Text('suggested'.tr,
                //                          style: rubikMedium.copyWith(
                //                              fontSize: Dimensions
                //                                  .FONT_SIZE_LARGE)),
                //                    ),
                //                    Container(
                //                      height: 80.0,
                //                      child: ListView.builder(
                //                          itemCount: requestMoneyController
                //                              .requestMoneySuggestList
                //                              .length,
                //                          scrollDirection: Axis.horizontal,
                //                          itemBuilder:
                //                              (context, index) =>
                //                                  CustomInkWell(
                //                                    radius: Dimensions
                //                                        .RADIUS_SIZE_VERY_SMALL,
                //                                    highlightColor:
                //                                        ColorResources
                //                                                .getPrimaryTextColor()
                //                                            .withOpacity(
                //                                                0.3),
                //                                    onTap: () {
                //                                      requestMoneyController
                //                                          .suggestOnTap(
                //                                              index,
                //                                              widget
                //                                                  .transactionType);
                //                                    },
                //                                    child: Container(
                //                                      margin: EdgeInsets.only(
                //                                          right: Dimensions
                //                                              .PADDING_SIZE_SMALL),
                //                                      child: Column(
                //                                        children: [
                //                                          SizedBox(
                //                                            height: Dimensions
                //                                                .RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                //                                            width: Dimensions
                //                                                .RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                //                                            child:
                //                                                ClipRRect(
                //                                              child: CustomImage(
                //                                                  image:
                //                                                      "$customerImageBaseUrl/${requestMoneyController.requestMoneySuggestList[index].avatarImage.toString()}",
                //                                                  fit: BoxFit
                //                                                      .cover,
                //                                                  placeholder:
                //                                                      Images
                //                                                          .avatar),
                //                                              borderRadius:
                //                                                  BorderRadius.circular(
                //                                                      Dimensions
                //                                                          .RADIUS_SIZE_OVER_LARGE),
                //                                            ),
                //                                          ),
                //                                          Padding(
                //                                            padding: const EdgeInsets
                //                                                    .only(
                //                                                top: Dimensions
                //                                                    .PADDING_SIZE_SMALL),
                //                                            child: Text(
                //                                                requestMoneyController.requestMoneySuggestList[index].name ==
                //                                                        null
                //                                                    ? requestMoneyController
                //                                                        .requestMoneySuggestList[
                //                                                            index]
                //                                                        .phoneNumber
                //                                                    : requestMoneyController
                //                                                        .requestMoneySuggestList[
                //                                                            index]
                //                                                        .name,
                //                                                style: requestMoneyController.requestMoneySuggestList[index].name ==
                //                                                        null
                //                                                    ? rubikLight.copyWith(
                //                                                        fontSize: Dimensions
                //                                                            .FONT_SIZE_LARGE)
                //                                                    : rubikRegular.copyWith(
                //                                                        fontSize:
                //                                                            Dimensions.FONT_SIZE_LARGE)),
                //                                          )
                //                                        ],
                //                                      ),
                //                                    ),
                //                                  )),
                //                    ),
                //                  ],
                //                ),
                //              );
                //      })
                //    : ((transactionMoneyController
                //                .cashOutSuggestList.isNotEmpty) &&
                //            widget.transactionType == 'cash_out')
                //        ? GetBuilder<TransactionMoneyController>(
                //            builder: (cashOutController) {
                //            return cashOutController.isLoading
                //                ? Center(child: CircularProgressIndicator())
                //                : Column(
                //                    mainAxisAlignment:
                //                        MainAxisAlignment.start,
                //                    crossAxisAlignment:
                //                        CrossAxisAlignment.start,
                //                    children: [
                //                      Padding(
                //                        padding: const EdgeInsets.symmetric(
                //                            vertical: Dimensions
                //                                .PADDING_SIZE_SMALL,
                //                            horizontal: Dimensions
                //                                .PADDING_SIZE_LARGE),
                //                        child: Text('recent_agent'.tr,
                //                            style: rubikMedium.copyWith(
                //                                fontSize: Dimensions
                //                                    .FONT_SIZE_LARGE)),
                //                      ),
                //                      ListView.builder(
                //                          itemCount: cashOutController
                //                              .cashOutSuggestList.length,
                //                          scrollDirection: Axis.vertical,
                //                          shrinkWrap: true,
                //                          physics:
                //                              NeverScrollableScrollPhysics(),
                //                          itemBuilder:
                //                              (context, index) =>
                //                                  CustomInkWell(
                //                                    highlightColor:
                //                                        ColorResources
                //                                                .getPrimaryTextColor()
                //                                            .withOpacity(
                //                                                0.3),
                //                                    onTap: () =>
                //                                        cashOutController
                //                                            .suggestOnTap(
                //                                                index,
                //                                                widget
                //                                                    .transactionType),
                //                                    child: Container(
                //                                      padding: EdgeInsets.symmetric(
                //                                          horizontal: Dimensions
                //                                              .PADDING_SIZE_LARGE,
                //                                          vertical: Dimensions
                //                                              .PADDING_SIZE_SMALL),
                //                                      child: Row(
                //                                        mainAxisAlignment:
                //                                            MainAxisAlignment
                //                                                .start,
                //                                        crossAxisAlignment:
                //                                            CrossAxisAlignment
                //                                                .center,
                //                                        children: [
                //                                          SizedBox(
                //                                            height: Dimensions
                //                                                .RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                //                                            width: Dimensions
                //                                                .RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                //                                            child:
                //                                                ClipRRect(
                //                                              child: FadeInImage
                //                                                  .assetNetwork(
                //                                                fit: BoxFit
                //                                                    .cover,
                //                                                image:
                //                                                    "$agentImageBaseUrl/${cashOutController.cashOutSuggestList[index].avatarImage.toString()}",
                //                                                placeholder:
                //                                                    Images
                //                                                        .avatar,
                //                                                imageErrorBuilder: (context,
                //                                                        url,
                //                                                        error) =>
                //                                                    Image
                //                                                        .asset(
                //                                                  Images
                //                                                      .avatar,
                //                                                  fit: BoxFit
                //                                                      .cover,
                //                                                ),
                //                                              ),
                //                                              borderRadius:
                //                                                  BorderRadius.circular(
                //                                                      Dimensions
                //                                                          .RADIUS_SIZE_OVER_LARGE),
                //                                            ),
                //                                          ),
                //                                          SizedBox(
                //                                            width: Dimensions
                //                                                .PADDING_SIZE_SMALL,
                //                                          ),
                //                                          Column(
                //                                            crossAxisAlignment:
                //                                                CrossAxisAlignment
                //                                                    .start,
                //                                            children: [
                //                                              Text(
                //                                                  cashOutController.cashOutSuggestList[index].name ==
                //                                                          null
                //                                                      ? 'Unknown'
                //                                                      : cashOutController
                //                                                          .cashOutSuggestList[
                //                                                              index]
                //                                                          .name,
                //                                                  style: rubikRegular.copyWith(
                //                                                      fontSize: Dimensions
                //                                                          .FONT_SIZE_LARGE,
                //                                                      color:
                //                                                          ColorResources.getBlackColor())),
                //                                              Text(
                //                                                cashOutController.cashOutSuggestList[index].phoneNumber !=
                //                                                        null
                //                                                    ? cashOutController
                //                                                        .cashOutSuggestList[index]
                //                                                        .phoneNumber
                //                                                    : 'No Number',
                //                                                style: rubikLight.copyWith(
                //                                                    fontSize:
                //                                                        Dimensions
                //                                                            .FONT_SIZE_DEFAULT,
                //                                                    color: ColorResources
                //                                                        .getGreyBaseGray1()),
                //                                              ),
                //                                            ],
                //                                          )
                //                                        ],
                //                                      ),
                //                                    ),
                //                                  )),
                //                    ],
                //                  );
                //          })
                //        : SizedBox(),
                // widget.transactionType != AppConstants.CASH_OUT
                //     ? GetBuilder<TransactionMoneyController>(
                //         builder: (contactController) {
                //         return ConstrainedBox(
                //             constraints: contactController
                //                         .filterdContacts.length >
                //                     0
                //                 ? BoxConstraints(
                //                     maxHeight:
                //                         Get.find<TransactionMoneyController>()
                //                                 .filterdContacts
                //                                 .length
                //                                 .toDouble() *
                //                             100)
                //                 : BoxConstraints(
                //                     maxHeight:
                //                         MediaQuery.of(context).size.height *
                //                             0.6),
                //             child: ContactView(
                //                 transactionType: widget.transactionType,
                //                 contactController: contactController));
                //       })
                //     : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<ResponseZopay> findUserViaPhone(String phoneNumber) async {
    final response = await ApiZopay()
        .getPublicUserCollection()
        .where('phone_number', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    if (response.docs.isNotEmpty) {
      userReceiver = ContactModel.fromJson(
          response.docs.first as DocumentSnapshot<Map<String, dynamic>>);
      final responseZopay = ResponseZopay(status: ApiZopay.STATUS_SUCCESS);
      return responseZopay;
    } else {
      final responseZopay = ResponseZopay(
          status: ApiZopay.STATUS_FAIL,
          message: "Số điện thoại chưa tham gia Zopay");
      return responseZopay;
    }
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 120 ||
        oldDelegate.minExtent != 120 ||
        child != oldDelegate.child;
  }
}
