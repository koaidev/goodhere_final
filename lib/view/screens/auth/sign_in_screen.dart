import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
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
import '../../../data/model/zopay/user_wallet.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;

  SignInScreen({@required this.exitFromApp});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();

  final TextEditingController _phoneController = TextEditingController();

  TextEditingController textEditingController = TextEditingController();
  String otpSent = "";
  bool isCodeSent = false;
  FocusNode otpFocusNode = FocusNode();
  String loginButtonName = 'sign_in'.tr;
  bool isLoading = false;
  bool firstLaunch = true;
  int endTime = 0;

  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Future<void> initState() async {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      final walletUser = await ApiZopay()
          .getUserWallet()
          .get();
      Get.lazyPut(() => walletUser.data());
    }
    _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? WebMenuBar()
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent)
                : null,
        endDrawer: MenuDrawer(),
        body: SafeArea(
            child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: FooterView(
                  child: Center(
                child: Container(
                  width: context.width > 700 ? 700 : context.width,
                  padding: context.width > 700
                      ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                      : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: context.width > 700
                      ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                      : EdgeInsets.zero,
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
                    var user = FirebaseAuth.instance.currentUser;
                    if (user != null && user.uid != null && firstLaunch) {
                      authController
                          .login(user.phoneNumber, user.uid)
                          .then((status) async {
                        if (status.isSuccess) {
                          Get.toNamed(
                              RouteHelper.getAccessLocationRoute('sign-in'));
                        } else {
                          showCustomSnackBar(status.message);
                        }
                      });

                      if (firstLaunch) {
                        firstLaunch = false;
                      }
                    }

                    return Column(children: [
                      Image.asset(Images.logo, width: 200),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                      Text('sign_in'.tr.toUpperCase(),
                          style: notoSerifBlack.copyWith(fontSize: 30)),
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
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: CustomTextField(
                                  hintText: 'phone'.tr,
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  // nextFocus: _passwordFocus,
                                  inputType: TextInputType.phone,
                                  divider: false,
                                  prefixIcon: Images.call,
                                )),
                          ]),
                        ]),
                      ),
                      SizedBox(height: 10),

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
                                widgetBuilder: (_, CurrentRemainingTime time) {
                                  if (time == null) {
                                    return TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          'Bạn chưa nhận được mã OTP? Gửi lại'),
                                    );
                                  }
                                  return Text('${time.sec}s');
                                },
                                endTime: endTime,
                              ),
                            ],
                          ),
                        ),
                        maintainAnimation: true,
                        maintainState: true,
                        visible: isCodeSent,
                      ),
                      Row(children: [
                        Expanded(
                          child: ListTile(
                            onTap: () => authController.toggleRememberMe(),
                            leading: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: authController.isActiveRememberMe,
                              onChanged: (bool isChecked) =>
                                  authController.toggleRememberMe(),
                            ),
                            title: Text('remember_me'.tr),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            horizontalTitleGap: 0,
                          ),
                        ),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      ConditionCheckBox(authController: authController),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      !isLoading
                          ? Row(children: [
                              Expanded(
                                  child: CustomButton(
                                buttonText: 'sign_up'.tr,
                                transparent: true,
                                onPressed: () =>
                                    Get.toNamed(RouteHelper.getSignUpRoute()),
                              )),
                              Expanded(
                                  child: CustomButton(
                                buttonText: loginButtonName,
                                onPressed: authController.acceptTerms
                                    ? () => _login(authController, "+84", false)
                                    : null,
                              )),
                            ])
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(height: 30),

                      // SocialLoginWidget(),

                      GuestButton(),
                    ]);
                  }),
                ),
              )),
            ),
          ),
        )),
      ),
    );
  }

  void _login(AuthController authController, String countryDialCode,
      bool resend) async {
    String _phone = _phoneController.text.trim();
    String _numberWithCountryCode = countryDialCode + _phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    FirebaseAuth auth = FirebaseAuth.instance;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }
    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      if (!isCodeSent) {
        setState(() {
          isCodeSent = true;
          otpFocusNode.requestFocus();
          loginButtonName = "Xác Minh";
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
                await authController
                    .login(value.user.phoneNumber, value.user.uid)
                    .then((status) async {
                  if (status.isSuccess) {
                    if (authController.isActiveRememberMe) {
                      authController.saveUserNumberAndPassword(
                          _phone, value.user.uid, countryDialCode);
                    } else {
                      authController.clearUserNumberAndPassword();
                    }
                    Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
                  } else {
                    showCustomSnackBar(status.message);
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
                    isLoading = false;
                  });
                  await authController
                      .login(value.user.phoneNumber, value.user.uid)
                      .then((status) async {
                    if (status.isSuccess) {
                      if (authController.isActiveRememberMe) {
                        authController.saveUserNumberAndPassword(
                            _phone, value.user.uid, countryDialCode);
                      } else {
                        authController.clearUserNumberAndPassword();
                      }
                      Get.toNamed(
                          RouteHelper.getAccessLocationRoute('sign-in'));
                    } else {
                      showCustomSnackBar("Lỗi đăng nhập: " + status.message);
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
}
