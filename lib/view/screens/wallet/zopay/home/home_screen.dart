import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/api/zopay_api.dart';
import 'package:sixam_mart/data/model/zopay/user_wallet.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/app_bar_base.dart';
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
  final ScrollController _scrollController = ScrollController();

  // final TransactionZopay transactions;

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
        body: RefreshIndicator(
            onRefresh: () async {
              // await _loadData(context, true);
            },
            child: Column(
              children: [
                FirstCardPortion(),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                // CustomScrollView(
                //   physics: AlwaysScrollableScrollPhysics(),
                //   controller: _scrollController,
                //   slivers: [
                //     SliverPersistentHeader(
                //         pinned: true,
                //         delegate: SliverDelegate(
                //             child: Container(
                //                 padding: EdgeInsets.symmetric(
                //                     vertical: Dimensions.PADDING_SIZE_SMALL),
                //                 height: 50,
                //                 alignment: Alignment.centerLeft,
                //                 child: ListView(
                //                     shrinkWrap: true,
                //                     padding: const EdgeInsets.only(
                //                         left: Dimensions.PADDING_SIZE_SMALL),
                //                     scrollDirection: Axis.horizontal,
                //                     children: [
                //                       TransactionTypeButton(
                //                           text: 'all'.tr,
                //                           index: 0,
                //                           transactionHistoryList: null),
                //                       SizedBox(width: 10),
                //                       TransactionTypeButton(
                //                           text: 'send_money'.tr,
                //                           index: 1,
                //                           transactionHistoryList: null),
                //                       SizedBox(width: 10),
                //                       TransactionTypeButton(
                //                           text: 'cash_in'.tr,
                //                           index: 2,
                //                           transactionHistoryList: null),
                //                       SizedBox(width: 10),
                //                       TransactionTypeButton(
                //                           text: 'add_money'.tr,
                //                           index: 3,
                //                           transactionHistoryList: null),
                //                       SizedBox(width: 10),
                //                       TransactionTypeButton(
                //                           text: 'received_money'.tr,
                //                           index: 4,
                //                           transactionHistoryList: null),
                //                       SizedBox(width: 10),
                //                       TransactionTypeButton(
                //                           text: 'cash_out'.tr,
                //                           index: 5,
                //                           transactionHistoryList: null),
                //                     ])))),
                //     SliverToBoxAdapter(
                //       child: Scrollbar(
                //         child: Padding(
                //           padding:
                //               EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                //           child: TransactionViewScreen(
                //               scrollController: _scrollController,
                //               isHome: false),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
                // GetBuilder<WebsiteLinkController>(builder: (websiteLinkController){
                //   return websiteLinkController.isLoading ?
                //   WebSiteShimmer() : websiteLinkController.websiteList.length > 0 ?  LinkedWebsite(websiteLinkController: websiteLinkController) : SizedBox();
                // }),
                // const SizedBox(height: 80),
              ],
            )),
      );
    });
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
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
