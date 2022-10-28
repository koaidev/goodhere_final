import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/app_bar_base.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/bottom_sheet/expandable_contant.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/bottom_sheet/persistent_header.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/first_card_portion.dart';

import '../../../../../controller/zopay/home_controller.dart';
import '../../../../../util/color_resources.dart';
import '../../../../../util/dimensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true;

  Future<void> _loadData(BuildContext context, bool reload) async {
    // await Get.find<ProfileController>().profileData(loading: true).then((value) {
    //   if(value.isOk){
    //      Get.find<BannerController>().getBannerList(reload);
    //      Get.find<RequestedMoneyController>().getRequestedMoneyList(1,context ,reload: reload );
    //      Get.find<RequestedMoneyController>().getOwnRequestedMoneyList(1 ,reload: reload );
    //      Get.find<TransactionHistoryController>().getTransactionData(1, reload: reload);
    //      Get.find<WebsiteLinkController>().getWebsiteList();
    //      Get.find<NotificationController>().getNotificationList();
    //      Get.find<TransactionMoneyController>().getPurposeList();
    //     Get.find<TransactionMoneyController>().fetchContact();
    //     if(reload) {
    //       Get.find<SplashController>().getConfigData();
    //     }
    //   }
    // });
  }

  @override
  void initState() {
    _loadData(context, true);
    isFirst = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        //backgroundColor: Theme.of(context).canvasColor,
        backgroundColor: ColorResources.getBackgroundColor(),
        appBar: AppBarBase(),
        body: ExpandableBottomSheet(
            enableToggle: true,
            background: RefreshIndicator(
              onRefresh: () async {
                await _loadData(context, true);
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    FirstCardPortion(),
                    // SecondCardPortion(),
                    // ThirdCardPortion(),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    // GetBuilder<WebsiteLinkController>(builder: (websiteLinkController){
                    //   return websiteLinkController.isLoading ?
                    //   WebSiteShimmer() : websiteLinkController.websiteList.length > 0 ?  LinkedWebsite(websiteLinkController: websiteLinkController) : SizedBox();
                    // }),
                    // const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            persistentContentHeight: 70,
            persistentHeader: CustomPersistentHeader(),
            expandableContent: CustomExpandableContant()),
      );
    });
  }
}
