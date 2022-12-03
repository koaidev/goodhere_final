import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/zopay/contact_model.dart';
import 'package:sixam_mart/data/model/zopay/new_user.dart';
import 'package:sixam_mart/data/model/zopay/user_info.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/auth/widget/condition_check_box.dart';
import 'package:sixam_mart/view/screens/auth/widget/guest_button.dart';

import '../../../data/api/zopay_api.dart';
import '../../../data/model/body/signup_body.dart';
import '../../../data/model/zopay/new_referrals.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();

  TextEditingController textEditingController = TextEditingController();
  String otpSent = "";
  bool isCodeSent = false;
  FocusNode otpFocusNode = FocusNode();
  String signupButtonName = 'sign_up'.tr;
  bool isLoading = false;
  int endTime = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      endDrawer: MenuDrawer(),
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.isDesktop(context)
              ? EdgeInsets.zero
              : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          child: FooterView(
            child: Center(
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: context.width > 700
                    ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                    : null,
                margin: context.width > 700
                    ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                    : null,
                decoration: context.width > 700
                    ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300],
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      )
                    : null,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column(children: [
                    Image.asset(Images.logo, width: 200),
                    // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                    Text('sign_up'.tr.toUpperCase(),
                        style: robotoBlack.copyWith(fontSize: 30)),
                    SizedBox(height: 50),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 800 : 200],
                              spreadRadius: 1,
                              blurRadius: 5)
                        ],
                      ),
                      child: Column(children: [
                        CustomTextField(
                          hintText: 'first_name'.tr,
                          controller: _firstNameController,
                          focusNode: _firstNameFocus,
                          nextFocus: _phoneFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          prefixIcon: Images.user,
                          divider: true,
                        ),
                        Row(children: [
                          Expanded(
                              child: CustomTextField(
                            hintText: 'phone'.tr,
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            nextFocus: _referCodeFocus,
                            inputType: TextInputType.phone,
                            prefixIcon: Images.call,
                            divider: false,
                          )),
                        ]),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: Divider(height: 1)),
                        (Get.find<SplashController>()
                                    .configModel
                                    .refEarningStatus ==
                                1)
                            ? CustomTextField(
                                hintText: 'refer_code'.tr,
                                controller: _referCodeController,
                                focusNode: _referCodeFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                                capitalization: TextCapitalization.words,
                                prefixIcon: Images.refer_code,
                                divider: false,
                                prefixSize: 14,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Column(
                                children: [
                                  Text(
                                    "enter_the_verification_sent_to".tr,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  PinCodeTextField(
                                    length: 6,
                                    obscureText: false,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 40,
                                      fieldWidth: 30,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.green,
                                    ),
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    backgroundColor: Colors.transparent,
                                    enableActiveFill: true,
                                    controller: textEditingController,
                                    onCompleted: (v) {
                                      print("Completed");
                                    },
                                    enablePinAutofill: true,
                                    focusNode: otpFocusNode,
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        otpSent = value;
                                      });
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");
                                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                      return true;
                                    },
                                    appContext: context,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CountdownTimer(
                                    // controller: controller,
                                    widgetBuilder:
                                        (_, CurrentRemainingTime time) {
                                      if (time == null) {
                                        return TextButton(
                                          onPressed: () => {
                                            isLoading
                                                ? null
                                                : _register(
                                                    authController, "+84")
                                          },
                                          child: Text(
                                              'Bạn chưa nhận được mã OTP? Gửi lại'),
                                        );
                                      }
                                      return Text('${time.sec}s');
                                    },
                                    endTime: endTime,
                                  ),
                                ],
                              )),
                          maintainAnimation: true,
                          maintainState: true,
                          visible: isCodeSent,
                        ),
                      ]),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    ConditionCheckBox(authController: authController),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    !authController.isLoading
                        ? Row(children: [
                            Expanded(
                                child: CustomButton(
                              buttonText: 'sign_in'.tr,
                              transparent: true,
                              onPressed: () => Get.toNamed(
                                  RouteHelper.getSignInRoute(
                                      RouteHelper.signUp)),
                            )),
                            Expanded(
                                child: CustomButton(
                              buttonText: signupButtonName,
                              onPressed: authController.acceptTerms
                                  ? () => _register(authController, "+84")
                                  : null,
                            )),
                          ])
                        : Center(child: CircularProgressIndicator()),
                    SizedBox(height: 30),
                    GuestButton(),
                  ]);
                }),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Future<void> shareMoneyForReferral(String referral) async {
    DocumentSnapshot referralExit = await ApiZopay()
        .getReferralsCollection()
        .withConverter(
            fromFirestore: (snapshot, options) =>
                NewReferral.fromJson(snapshot, options),
            toFirestore: (NewReferral newReferral, options) =>
                newReferral.toJson())
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    if (!referralExit.exists) {
      await ApiZopay().shareMoneyForReferral(referral);
    }
  }

  void _register(AuthController authController, String countryCode) async {
    String _firstName = _firstNameController.text.trim();
    String _number = _phoneController.text.trim();
    String _referCode = _referCodeController.text.toString().trim();
    FirebaseAuth auth = FirebaseAuth.instance;
    String _numberWithCountryCode = countryCode + _number;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }
    bool _validReferral = false;
    if (_referCode.isNotEmpty) {
      try {
        await PhoneNumberUtil().parse("+84$_referCode");
        _validReferral = true;
      } catch (e) {
        _validReferral = false;
      }
    }

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if ((_referCode.isNotEmpty &&
        !_validReferral) ||
        _referCode == _number) {
      showCustomSnackBar('invalid_refer_code'.tr);
    } else {
      if (!isCodeSent) {
        setState(() {
          isCodeSent = true;
          otpFocusNode.requestFocus();
          signupButtonName = "Xác Minh";
          endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
        });
      } else {
        setState(() {
          isLoading = true;
        });
      }
      await auth.verifyPhoneNumber(
          phoneNumber: _numberWithCountryCode,
          verificationCompleted: (PhoneAuthCredential credential) async {
            setState(() {
              isLoading = false;
            });
            // Sign the user in (or link) with the credential
            await auth.signInWithCredential(credential).then((value) async {
              if (value.user != null) {
                setState(() {
                  isLoading = authController.isLoading;
                });
                SignUpBody signUpBody = SignUpBody(
                  fName: _firstName,
                  phone: value.user.phoneNumber,
                  password: value.user.uid,
                  refCode: _referCode,
                );
                authController.registration(signUpBody).then((status) async {
                  if (status.isSuccess) {
                    if (authController.isActiveRememberMe) {
                      authController.saveUserNumberAndPassword(
                          _number, value.user.uid, countryCode);
                    } else {
                      authController.clearUserNumberAndPassword();
                    }

                    var key = utf8.encode(value.user.uid);
                    var bytes = utf8.encode("1111");

                    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
                    var digest = hmacSha256.convert(bytes);

                    final user = UserInfoZopay(
                        name: _firstName,
                        phone: value.user.phoneNumber.replaceAll("+84", "0"),
                        pin: digest.toString(),
                        referralCode: _number,
                        uid: value.user.uid,
                        qrCode: '$_number $_firstName');
                    final userIsExits = await ApiZopay().checkUserIsExits();
                    if (!userIsExits) {
                      _registerZopay(user, referCode: _referCode).then((value2) async {
                        if (!value2) {
                          showCustomSnackBar("Lỗi đã xảy ra!", isError: true);
                        } else {
                          authController
                              .login(value.user.phoneNumber, value.user.uid)
                              .then((value) => {
                                    if (value.isSuccess)
                                      {
                                        Get.toNamed(
                                            RouteHelper.getAccessLocationRoute(
                                                RouteHelper.signUp))
                                      }
                                  });
                        }
                      });
                    } else {
                      authController
                          .login(value.user.phoneNumber, value.user.uid)
                          .then((value) => {
                                if (value.isSuccess)
                                  {
                                    Get.toNamed(
                                        RouteHelper.getAccessLocationRoute(
                                            RouteHelper.signUp))
                                  }
                              });
                    }
                  } else {
                    showCustomSnackBar(
                        "Lỗi đăng ký tài khoản: " + status.message);
                  }
                });
              }
            });
          },
          timeout: const Duration(seconds: 60),
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              showCustomSnackBar("Số điện thoại không khả dụng", isError: true);
            } else {
              showCustomSnackBar(e.message, isError: true);
            }
            setState(() {
              isLoading = false;
            });
          },
          codeSent: (String verificationId, int resendToken) async {
            if (otpSent.length == 6) {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: otpSent);

              // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential).then((value) async {
                if (value.user != null) {
                  setState(() {
                    isLoading = authController.isLoading;
                  });
                  SignUpBody signUpBody = SignUpBody(
                    fName: _firstName,
                    email: value.user.uid,
                    phone: value.user.phoneNumber,
                    password: value.user.uid,
                    refCode: _referCode,
                  );
                  authController.registration(signUpBody).then((status) async {
                    if (status.isSuccess) {
                      if (authController.isActiveRememberMe) {
                        authController.saveUserNumberAndPassword(
                            _number, value.user.uid, countryCode);
                      } else {
                        authController.clearUserNumberAndPassword();
                      }
                      var key = utf8.encode(value.user.uid);
                      var bytes = utf8.encode("1111");

                      var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
                      var digest = hmacSha256.convert(bytes);
                      final user = UserInfoZopay(
                          name: _firstName,
                          phone: value.user.phoneNumber.replaceAll("+84", "0"),
                          pin: digest.toString(),
                          referralCode: _number,
                          uid: value.user.uid,
                          qrCode: '$_number $_firstName');
                      final userIsExits = await ApiZopay().checkUserIsExits();
                      if (!userIsExits) {
                        _registerZopay(user, referCode: _referCode).then((value2) async {
                          if (!value2) {
                            showCustomSnackBar("Lỗi đã xảy ra!", isError: true);
                          } else {
                            authController
                                .login(value.user.phoneNumber, value.user.uid)
                                .then((value) => {
                                      if (value.isSuccess)
                                        {
                                          Get.toNamed(RouteHelper
                                              .getAccessLocationRoute(
                                                  RouteHelper.signUp))
                                        }
                                    });
                          }
                        });
                      } else {
                        authController
                            .login(value.user.phoneNumber, value.user.uid)
                            .then((value) => {
                                  if (value.isSuccess)
                                    {
                                      Get.toNamed(
                                          RouteHelper.getAccessLocationRoute(
                                              RouteHelper.signUp))
                                    }
                                });
                      }
                    } else {
                      showCustomSnackBar(
                          "Lỗi đăng ký tài khoản: " + status.message);
                    }
                  });
                }
              });
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          autoRetrievedSmsCodeForTesting: "123456");
    }
  }

  Future<bool> _registerZopay(UserInfoZopay userInfoZopay, {String referCode}) async {
    await ApiZopay().requestMoneyForFirstTime(NewUser(uid: userInfoZopay.uid));
    await ApiZopay().getPublicUser().set(ContactModel(
        phoneNumber: userInfoZopay.referralCode,
        name: userInfoZopay.name,
        role: "user",
        avatarImage: userInfoZopay.image));
    if (referCode.isNotEmpty) {
      await shareMoneyForReferral(referCode);
    }
    return await ApiZopay().register(userInfoZopay);
  }
}
