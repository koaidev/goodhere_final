import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/api/zopay_api.dart';

import '../../data/model/zopay/abank.dart';
import '../../util/dimensions.dart';
import '../../view/base/custom_button.dart';
import '../../view/base/custom_snackbar.dart';
import 'bank_field.dart';

class AddBankBottomSheet extends StatelessWidget {
  final String bankName;
  final String branchName;
  final String holderName;
  final String accountNo;

  AddBankBottomSheet(
      {this.bankName, this.branchName, this.holderName, this.accountNo});

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  final FocusNode _bankNameFocus = FocusNode();
  final FocusNode _branchNameFocus = FocusNode();
  final FocusNode _holderNameFocus = FocusNode();
  final FocusNode _accountNoFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _bankNameController.text = bankName ?? '';
    _branchNameController.text = branchName ?? '';
    _holderNameController.text = holderName ?? '';
    _accountNoController.text = accountNo ?? '';

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.RADIUS_LARGE)),
      ),
      child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        BankField(
          hintText: 'bank_name'.tr,
          controller: _bankNameController,
          focusNode: _bankNameFocus,
          nextFocus: _branchNameFocus,
          capitalization: TextCapitalization.words,
        ),
        BankField(
          hintText: 'branch_name'.tr,
          controller: _branchNameController,
          focusNode: _branchNameFocus,
          nextFocus: _holderNameFocus,
          capitalization: TextCapitalization.words,
        ),
        BankField(
          hintText: 'holder_name'.tr,
          controller: _holderNameController,
          focusNode: _holderNameFocus,
          nextFocus: _accountNoFocus,
          capitalization: TextCapitalization.words,
        ),
        BankField(
          hintText: 'account_no'.tr,
          controller: _accountNoController,
          focusNode: _accountNoFocus,
          inputAction: TextInputAction.done,
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        CustomButton(
          buttonText: bankName != null ? 'update'.tr : 'add_bank'.tr,
          onPressed: () async {
            String _bankName = _bankNameController.text.trim();
            String _branchName = _branchNameController.text.trim();
            String _holderName = _holderNameController.text.trim();
            String _accountNo = _accountNoController.text.trim();
            if (bankName != null &&
                _bankName == bankName &&
                _branchName == branchName &&
                _holderName == holderName &&
                _accountNo == accountNo) {
              showCustomSnackBar('change_something_to_update'.tr);
            } else if (_bankName.isEmpty) {
              showCustomSnackBar('enter_bank_name'.tr);
            } else if (_branchName.isEmpty) {
              showCustomSnackBar('enter_branch_name'.tr);
            } else if (_holderName.isEmpty) {
              showCustomSnackBar('enter_holder_name'.tr);
            } else if (_accountNo.isEmpty) {
              showCustomSnackBar('enter_account_no'.tr);
            } else {
              ABank aBank = ABank(
                  bankName: _bankName,
                  noCard: _accountNo,
                  cardUserName: _holderName,
                  branch: _branchName,
                  uid: ApiZopay().uid);
              final response = await ApiZopay().addBankAccount(aBank);
              if (response) {
                showCustomSnackBar("Cập nhật thành công");
              } else {
                showCustomSnackBar("Lỗi đã xảy ra, vui lòng thử lại sau.",
                    isError: true);
              }
              Navigator.pop(context);
            }
          },
        )
      ])),
    );
  }
}
