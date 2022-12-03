import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/transaction_money_balance_input.dart';

import '../../../../../data/api/zopay_api.dart';
import '../../../../../data/model/zopay/contact_model.dart';
import '../../../../../data/model/zopay/response_zopay.dart';
import '../../../../../data/model/zopay/user_info.dart';
import '../../../../../data/model/zopay/user_wallet.dart';
import '../../../../../util/color_resources.dart';
import '../../../../../util/dimensions.dart';
import '../../../../../util/images.dart';
import '../../../../base/custom_snackbar.dart';
import '../../../../base/zopay/custom_app_bar.dart';
import '../../../../base/zopay/custom_ink_well.dart';

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
  bool currentTaskStatus = false;
  UserWallet userWallet;
  String idReceiver;


  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    widget.fromEdit ? _searchController.text = widget.phoneNumber : SizedBox();

    return StreamBuilder<DocumentSnapshot>(
        stream: Get.find<ApiZopay>().getUserStream(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          final UserInfoZopay user =
              snapshot.data.data() ?? UserInfoZopay(name: "No Name");
          return Scaffold(
              appBar: CustomAppbar(
                  title: widget.transactionType == "send_money"
                      ? 'send_money'.tr
                      : widget.transactionType == 'cash_out'
                          ? 'cash_out'.tr
                          : 'request_money'.tr),
              body: StreamBuilder<DocumentSnapshot>(
                stream: Get.find<ApiZopay>().getUserWallet(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    userWallet = UserWallet(uid: Get.find<ApiZopay>().uid);
                  }
                  if (snapshot.hasData) {
                    userWallet = snapshot.data.data() ??
                        UserWallet(uid: Get.find<ApiZopay>().uid);
                  }
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverDelegate(
                              child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_SMALL,
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT),
                                color: ColorResources.getGreyBaseGray3(),
                                child: Row(children: [
                                  Expanded(
                                      child: TextField(
                                          controller: _searchController,
                                          onChanged: (inputText) async {
                                            if (inputText.isNotEmpty) {
                                              var _isValid = false;
                                              try {
                                                await PhoneNumberUtil()
                                                    .parse("+84$inputText");
                                                _isValid = true;
                                              } catch (e) {}
                                              if (_isValid) {
                                                if (inputText !=
                                                    widget.phoneNumber) {
                                                  await findUserViaPhone(
                                                      inputText);
                                                  setState(() {});
                                                } else {
                                                  if (widget.transactionType ==
                                                          "cash_out" &&
                                                      user.role == "user") {
                                                    if (userWallet.pointMain >=
                                                        1020000) {
                                                      await findUserViaPhone(
                                                          inputText);
                                                      setState(() {});
                                                    } else {
                                                      showCustomSnackBar(
                                                          "Số dư bạn không đủ để rút trực tiếp. Vui lòng liên hệ đại lý gần nhất để rút tiền.");
                                                    }
                                                  } else {
                                                    if (widget
                                                            .transactionType ==
                                                        "send_money") {
                                                      showCustomSnackBar(
                                                          "Bạn không thể gửi điểm cho chính mình",
                                                          isError: true);
                                                    } else {
                                                      await findUserViaPhone(
                                                          inputText);
                                                      setState(() {});
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          },
                                          keyboardType:
                                              widget.transactionType ==
                                                      'cash_out'
                                                  ? TextInputType.phone
                                                  : TextInputType.name,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                top: Dimensions
                                                    .PADDING_SIZE_DEFAULT),
                                            hintText: widget.transactionType !=
                                                    'cash_out'
                                                ? 'Nhập số điện thoại người nhận'
                                                : 'Nhập số điện thoại đại lý',
                                            hintStyle: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE,
                                                color: ColorResources
                                                    .getGreyBaseGray1()),
                                          ))),
                                  Icon(Icons.search,
                                      color: ColorResources.getGreyBaseGray1()),
                                ]),
                              ),
                              // Divider(
                              //     height: Dimensions.DIVIDER_SIZE_SMALL,
                              //     color: ColorResources.BACKGROUND_COLOR),
                              // Container(
                              //   color: ColorResources.getWhiteColor(),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: Dimensions.PADDING_SIZE_LARGE,
                              //         vertical: Dimensions.PADDING_SIZE_SMALL),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         ScanButton(
                              //             onTap: () => Get.to(() => CameraScreen(
                              //                   fromEditProfile: false,
                              //                   isBarCodeScan: true,
                              //                   transactionType: widget.transactionType,
                              //                 ))),
                              //         InkWell(
                              //             onTap: () {
                              //               if (_searchController.text.isEmpty) {
                              //                 showCustomSnackBar('input_field_is_empty'.tr,
                              //                     isError: true);
                              //               } else {
                              //                 if (widget.transactionType == "cash_out") {
                              //                   Get.to(() => TransactionMoneyBalanceInput(
                              //                       transactionType: widget.transactionType,
                              //                       contactModel: ContactModel(
                              //                           phoneNumber:
                              //                               userReceiver.phoneNumber,
                              //                           name: userReceiver.name,
                              //                           avatarImage:
                              //                               userReceiver.avatarImage)));
                              //                 } else {
                              //                   Get.to(() => TransactionMoneyBalanceInput(
                              //                       transactionType: widget.transactionType,
                              //                       contactModel: ContactModel(
                              //                           phoneNumber:
                              //                               userReceiver.phoneNumber,
                              //                           name: userReceiver.name,
                              //                           avatarImage:
                              //                               userReceiver.avatarImage)));
                              //                 }
                              //               }
                              //             },
                              //             child: Container(
                              //                 width: Dimensions.RADIUS_SIZE_OVER_LARGE,
                              //                 height: Dimensions.RADIUS_SIZE_OVER_LARGE,
                              //                 decoration: BoxDecoration(
                              //                     shape: BoxShape.circle,
                              //                     color: Colors.green),
                              //                 child: Icon(Icons.arrow_forward,
                              //                     color: ColorResources.whiteColor))),
                              //       ],
                              //     ),
                              //   ),
                              // )
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
                                  Visibility(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            child: Text('Hướng dẫn:',
                                                style: robotoBold.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Text(
                                              widget.transactionType !=
                                                      'cash_out'
                                                  ? '- Nhập số điện thoại người nhận vào mục tìm kiếm.'
                                                  : '- Nhập số điện thoại đại lý vào tìm kiếm.',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Text(
                                              '- Tại vị trí đề xuất, xác nhận danh tính người nhận và chọn để tiếp tục.',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Text(
                                              '- Bạn chỉ có thể thực hiện chuyển, gửi điểm bằng số điểm có ở tài khoản chính. Phí giao dịch được quy định theo Chính sách thanh toán Zopay.',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        )
                                      ],
                                    ),
                                    visible: userReceiver == null,
                                  ),
                                  Visibility(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: Text('suggested'.tr,
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)),
                                    ),
                                    visible: userReceiver != null,
                                  ),
                                  Visibility(
                                    child: Container(
                                      height: 80.0,
                                      child: ListView.builder(
                                          itemCount:
                                              userReceiver != null ? 1 : 0,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              CustomInkWell(
                                                radius: Dimensions
                                                    .RADIUS_SIZE_VERY_SMALL,
                                                highlightColor: ColorResources
                                                        .getPrimaryTextColor()
                                                    .withOpacity(0.3),
                                                onTap: () {
                                                  Get.to(() =>
                                                      TransactionMoneyBalanceInput(
                                                        transactionType: widget
                                                            .transactionType,
                                                        contactModel: ContactModel(
                                                            phoneNumber:
                                                                userReceiver
                                                                    .phoneNumber,
                                                            name: userReceiver
                                                                .name,
                                                            avatarImage:
                                                                userReceiver
                                                                    .avatarImage,
                                                            role: userReceiver
                                                                .role),
                                                        userInfoZopay: user,
                                                        idReceiver: idReceiver,
                                                      ));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: Dimensions
                                                          .PADDING_SIZE_SMALL),
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
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .RADIUS_SIZE_OVER_LARGE),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                                .only(
                                                            top: Dimensions
                                                                .PADDING_SIZE_SMALL),
                                                        child: Text(
                                                            userReceiver != null
                                                                ? "${userReceiver.name} - ${userReceiver.phoneNumber}"
                                                                : "",
                                                            style: robotoRegular
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_SMALL)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    ),
                                    visible: userReceiver != null,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ));
        });
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
      idReceiver = response.docs.first.id;
      final responseZopay = ResponseZopay(status: ApiZopay.STATUS_SUCCESS);
      if (widget.transactionType == "cash_out") {
        if (userReceiver.phoneNumber != widget.phoneNumber) {
          return ResponseZopay(
              status: ApiZopay.STATUS_FAIL,
              message: "Số điện thoại chưa tham gia Zopay");
        } else {
          return responseZopay;
        }
      } else {
        return responseZopay;
      }
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
