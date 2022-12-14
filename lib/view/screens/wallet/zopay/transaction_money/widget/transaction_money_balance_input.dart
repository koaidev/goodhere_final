import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/data/model/zopay/add_money.dart';
import 'package:sixam_mart/data/model/zopay/user_wallet.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/transaction_money/widget/transaction_money_confirmation.dart';

import '../../../../../../controller/localization_controller.dart';
import '../../../../../../controller/zopay/purpose_models.dart';
import '../../../../../../data/api/zopay_api.dart';
import '../../../../../../data/model/zopay/contact_model.dart';
import '../../../../../../data/model/zopay/user_info.dart';
import '../../../../../../helper/network_info.dart';
import '../../../../../../helper/price_converter.dart';
import '../../../../../../util/app_constants.dart';
import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';
import '../../../../../../util/images.dart';
import '../../../../../base/custom_snackbar.dart';
import '../../../../../base/image_picker_widget.dart';
import '../../../../../base/zopay/custom_app_bar.dart';
import '../../../../checkout/checkout_screen.dart';
import 'for_person_widget.dart';
import 'next_button.dart';

class TransactionMoneyBalanceInput extends StatefulWidget {
  final String transactionType;
  final ContactModel contactModel;
  final UserInfoZopay userInfoZopay;
  final String idReceiver;

  TransactionMoneyBalanceInput({Key key,
    this.transactionType,
    this.contactModel,
    @required this.userInfoZopay,
    this.idReceiver})
      : super(key: key);

  @override
  State<TransactionMoneyBalanceInput> createState() =>
      _TransactionMoneyBalanceInputState();
}

class _TransactionMoneyBalanceInputState
    extends State<TransactionMoneyBalanceInput> {
  final TextEditingController _inputAmountController = TextEditingController();
  UserWallet userWallet;
  double amount = 0.0;
  bool currentTaskStatus = false;
  int feePercent = 0;
  Uint8List _rawAttachment;
  XFile _orderAttachment;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LocalizationController localizationController =
    Get.find<LocalizationController>();
    final size = MediaQuery
        .of(context)
        .size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: CustomAppbar(
              title: widget.transactionType == 'send_money'
                  ? 'send_money'.tr
                  : widget.transactionType == 'cash_out'
                  ? 'cash_out'.tr
                  : widget.transactionType == 'request_money'
                  ? 'request_money'.tr
                  : 'add_money'.tr),
          body: StreamBuilder<DocumentSnapshot>(
              stream: Get.find<ApiZopay>().getUserWallet(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  userWallet = UserWallet(uid: Get
                      .find<ApiZopay>()
                      .uid);
                }
                if (snapshot.hasData) {
                  userWallet = snapshot.data.data() ??
                      UserWallet(uid: Get
                          .find<ApiZopay>()
                          .uid);
                  if (widget.transactionType == "send_money" &&
                      widget.contactModel.role == "user" &&
                      widget.userInfoZopay.role == "user") {
                    feePercent = 2;
                  } else {
                    feePercent = 0;
                  }
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.transactionType != 'add_money'
                          ? ForPersonWidget(contactModel: widget.contactModel)
                          : SizedBox.shrink(),
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                color: ColorResources.getWhiteAndBlack(),
                                child: Column(
                                  children: [
                                    Container(
                                      width: size.width * 0.6,
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                          Dimensions.PADDING_SIZE_LARGE),
                                      child: TextField(
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(
                                              AppConstants.BALANCE_INPUT_LEN +
                                                  (AppConstants
                                                      .BALANCE_INPUT_LEN /
                                                      3)
                                                      .floor()),
                                          CurrencyTextInputFormatter(
                                            locale: 'vi',
                                            decimalDigits: 0,
                                            symbol: '\đ',
                                          ),
                                        ],
                                        keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        controller: _inputAmountController,
                                        textAlignVertical:
                                        TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        style: robotoMedium.copyWith(
                                            fontSize: 34,
                                            color: ColorResources
                                                .getPrimaryTextColor()),
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          hintText:
                                          '${PriceConverter
                                              .balanceInputHint()}',
                                          border: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(),
                                          hintStyle: robotoMedium.copyWith(
                                              fontSize: 34,
                                              color: ColorResources
                                                  .getPrimaryTextColor()
                                                  .withOpacity(0.7)),
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty &&
                                              widget.transactionType !=
                                                  "add_money") {
                                            String balance =
                                                _inputAmountController.text;
                                            print(
                                                'Balance origin: $balance - $amount');

                                            if (balance.contains('\đ')) {
                                              balance =
                                                  balance.replaceAll('\đ', '');
                                            }
                                            print(
                                                'Balance 2: $balance - $amount');
                                            if (balance.contains('.')) {
                                              balance =
                                                  balance.replaceAll('.', '');
                                            }
                                            print(
                                                'Balance 3: $balance - $amount');
                                            if (balance.contains(' ')) {
                                              balance =
                                                  balance.replaceAll(' ', '');
                                            }
                                            amount = double.parse(balance);
                                            print(
                                                'Balance final: $balance - $amount');
                                            if (amount *
                                                (100 + feePercent) /
                                                100 >
                                                userWallet.pointMain &&
                                                !currentTaskStatus) {
                                              currentTaskStatus = true;
                                              showCustomSnackBar(
                                                  'Số dư hiện tại không khả dụng.',
                                                  isError: true);
                                            }
                                          }
                                          if (widget.transactionType ==
                                              "send_money" &&
                                              widget.contactModel.role ==
                                                  "user" &&
                                              widget.userInfoZopay.role ==
                                                  "user") {
                                            feePercent = 2;
                                          } else {
                                            feePercent = 0;
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: Dimensions.PADDING_SIZE_SMALL,
                                          right: Dimensions.PADDING_SIZE_SMALL,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text("Phí giao dịch: ")),
                                            Expanded(
                                                child: Text(
                                                    PriceConverter.convertPrice(
                                                        (amount /
                                                            100 *
                                                            feePercent)
                                                            .toInt())))
                                          ],
                                        ),
                                      ),
                                      visible: amount >= 1000 &&
                                          widget.transactionType != "add_money",
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: Dimensions.PADDING_SIZE_SMALL,
                                            right:
                                            Dimensions.PADDING_SIZE_SMALL),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text("Tổng chi phí: ")),
                                            Expanded(
                                                child: Text(
                                                    PriceConverter.convertPrice(
                                                        amount *
                                                            (100 +
                                                                feePercent) ~/
                                                            100)))
                                          ],
                                        ),
                                      ),
                                      visible: amount >= 1000 &&
                                          widget.transactionType != "add_money",
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                        child: Text(
                                            widget.transactionType !=
                                                "add_money"
                                                ? '${'available_balance'
                                                .tr} ${PriceConverter
                                                .convertPrice(
                                                userWallet.pointMain)}'
                                                : 'Số dư hiện tại ${PriceConverter
                                                .convertPrice(
                                                userWallet.pointMain)}',
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                                color: ColorResources
                                                    .getGreyColor()))),
                                    SizedBox(),
                                    if (widget.transactionType == 'add_money')
                                      Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      bottom: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: Text('Hướng dẫn:',
                                                      style: robotoBold
                                                          .copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  '- Để nạp điểm vào tài khoản Zopay, vui lòng thực hiện các bước sau:',
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    '+ Chuyển tiền tới số tài khoản:',
                                                    style: robotoBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '1900 9999 07\nCONG TY TNHH GOOD HERE\nNgân hàng MB Bank',
                                                    style: robotoBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE,
                                                        color: Colors.green)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    '+ Cú pháp chuyển khoản:',
                                                    style: robotoBold.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE,
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    'NAP DIEM GOOD HERE - SĐT ĐÃ ĐĂNG KÝ GOOD HERE',
                                                    style: robotoBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE,
                                                        color: Colors.green)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    '** Ví dụ: NAP DIEM GOOD HERE - 0987654321',
                                                    style:
                                                    robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE,
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: _buildActionCopy(
                                                          "Copy Số Tài Khoản",
                                                          action: () {
                                                            Clipboard.setData(
                                                                ClipboardData(
                                                                    text: "719121314"));
                                                            showCustomSnackBar(
                                                                "Đã sao chép: 719121314");
                                                          })),
                                                  Expanded(
                                                      child: _buildActionCopy(
                                                          "Copy Cú Pháp",
                                                          action: () {
                                                            Clipboard.setData(
                                                                ClipboardData(
                                                                    text:
                                                                    "NAP DIEM GOOD HERE - ${widget
                                                                        .userInfoZopay
                                                                        .phone}"));
                                                            showCustomSnackBar(
                                                                "Đã sao chép: NAP DIEM GOOD HERE - ${widget
                                                                    .userInfoZopay
                                                                    .phone}");
                                                          })),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    '+ Chụp ảnh màn hình giao dịch thành công và gửi ảnh cho Good Here.',
                                                    style: robotoBold.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE,
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ImagePickerWidget(
                                                image: '',
                                                rawFile: _rawAttachment,
                                                onTap: () {
                                                  pickImage();
                                                },
                                                isOval: false,
                                              ),
                                            ],
                                          )),
                                    SizedBox(
                                      height: Dimensions.PADDING_SIZE_DEFAULT,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(),
                              widget.transactionType != 'cash_out' &&
                                  widget.transactionType != 'add_money'
                                  ? localizationController.isLtr
                                  ? Positioned(
                                  right: 10,
                                  bottom: 5,
                                  child: Image.asset(
                                      Images.input_stack_desing,
                                      width: 150.0))
                                  : Positioned(
                                  left: 10,
                                  bottom: 5,
                                  child: Transform(
                                      transform:
                                      Matrix4.rotationY(math.pi),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                          Images.input_stack_desing,
                                          width: 150.0)))
                                  : SizedBox(),
                            ],
                          ),
                          if (widget.transactionType == "cash_out" &&
                              widget.contactModel.role == "user")
                            Padding(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom:
                                            Dimensions.PADDING_SIZE_SMALL),
                                        child: Text('Hướng dẫn:',
                                            style: robotoBold.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        '- Bạn có thể tự rút tiền về tài khoản mình khi số dư tài khoản chính của bạn tối thiểu là 1.000.000 điểm.',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                            Dimensions.FONT_SIZE_LARGE)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        '- Nếu số dư bạn không đủ theo điều kiện trên, bạn có thể liên hệ đại lý gần nhất trực thuộc Good Here để thực hiện rút tiền hoặc liên hệ tới số 1900.9999.07 để được hỗ trợ.',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                            Dimensions.FONT_SIZE_LARGE)),
                                  ],
                                )),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_inputAmountController.text.isEmpty) {
                showCustomSnackBar('please_input_amount'.tr, isError: true);
              } else {
                String balance = _inputAmountController.text;
                print('Balance origin: $balance - $amount');

                if (balance.contains('\đ')) {
                  balance = balance.replaceAll('\đ', '');
                }
                print('Balance 2: $balance - $amount');
                if (balance.contains('.')) {
                  balance = balance.replaceAll('.', '');
                }
                print('Balance 3: $balance - $amount');
                if (balance.contains(' ')) {
                  balance = balance.replaceAll(' ', '');
                }
                amount = double.parse(balance);
                print('Balance final: $balance - $amount');
                if (amount == 0) {
                  showCustomSnackBar('transaction_amount_must_be'.tr,
                      isError: true);
                } else {
                  if (widget.transactionType != "add_money" &&
                      amount * (100 + feePercent) / 100 >
                          userWallet.pointMain) {
                    showCustomSnackBar('insufficient_balance'.tr,
                        isError: true);
                  } else {
                    if (widget.transactionType == "add_money") {
                      if (_rawAttachment == null) {
                        showCustomSnackBar(
                            'Bạn cần chụp màn hình giao dịch trước.',
                            isError: true);
                      } else {
                        final transactionId =
                            getRandomString(5) + DateTime
                                .now()
                                .microsecondsSinceEpoch
                                .toString();
                        final urlImage = await uploadImage(transactionId);

                        final addMoney = AddMoney(id: transactionId,
                            uid: widget.userInfoZopay.uid,
                            name: widget.userInfoZopay.name,
                            image: urlImage,
                            amount: amount.toInt(),
                            dateCreate: DateTime.now().millisecondsSinceEpoch,
                            status: "need_handle");
                        final response = await ApiZopay()
                            .createNewAddMoneyRequest(addMoney);
                        if(response){
                          showCustomSnackBar("Yêu cầu của bạn đã được xử lý.");
                          Get.offNamed(RouteHelper.initial);
                        }else{
                          showCustomSnackBar("Lỗi đã xảy ra. Vui lòng thực hiện sau ít phút.", isError: true);
                        }
                      }
                    } else if (widget.transactionType == 'cash_out') {
                      if (widget.userInfoZopay.role == "user") {
                        if (userWallet.pointMain < 1000000) {
                          showCustomSnackBar(
                              "Bạn chỉ có thể rút điểm trực tiếp khi số dư của bạn từ 1.000.000 trở lên. Vui lòng liên hệ đại lý gần nhất để thực hiện rút thủ công.",
                              isError: true);
                        } else {
                          Get.to(() =>
                              TransactionMoneyConfirmation(
                                inputBalance: amount,
                                transactionType: widget.transactionType,
                                purpose: Purpose().title,
                                contactModel: widget.contactModel,
                                feePercent: feePercent,
                                idReceiver: widget.userInfoZopay.uid,
                              ));
                        }
                      } else {
                        Get.to(() =>
                            TransactionMoneyConfirmation(
                              inputBalance: amount,
                              transactionType: widget.transactionType,
                              purpose: Purpose().title,
                              contactModel: widget.contactModel,
                              feePercent: feePercent,
                              idReceiver: widget.userInfoZopay.uid,
                            ));
                      }
                    } else {
                      Get.to(() =>
                          TransactionMoneyConfirmation(
                            inputBalance: amount,
                            transactionType: widget.transactionType,
                            purpose: Purpose().title,
                            contactModel: widget.contactModel,
                            feePercent: feePercent,
                            idReceiver: widget.idReceiver,
                          ));
                    }
                  }
                }
              }
              // }
            },
            child: NextButton(isSubmittable: true),
            backgroundColor: Theme
                .of(context)
                .secondaryHeaderColor,
          )),
    );
  }

  Widget _buildActionCopy(String title, {Function action}) {
    return GestureDetector(
      onTap: () {
        action?.call();
      },
      child: Row(
        children: [
          Icon(
            Icons.copy_sharp,
            color: Colors.green,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            title,
            style: robotoMedium,
          )
        ],
      ),
    );
  }


  void pickImage() async {
    _orderAttachment = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (_orderAttachment != null) {
      _orderAttachment = await NetworkInfo.compressImage(_orderAttachment);
      _rawAttachment = await _orderAttachment.readAsBytes();
    }
    setState(() {});
  }

  Future<String> uploadImage(String id) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("images").child(ApiZopay().uid).child(id);
    await imagesRef.putData(_rawAttachment);
    return await imagesRef.getDownloadURL();
  }
}
