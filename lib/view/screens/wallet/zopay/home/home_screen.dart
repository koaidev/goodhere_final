import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/api/zopay_api.dart';
import 'package:sixam_mart/data/model/zopay/transaction_zopay.dart';
import 'package:sixam_mart/data/model/zopay/user_info.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/app_bar_base.dart';
import 'package:sixam_mart/view/screens/wallet/zopay/home/widget/first_card_portion.dart';

import '../../../../../controller/zopay/home_controller.dart';
import '../../../../../util/color_resources.dart';
import '../../../../../util/dimensions.dart';
import '../history/widget/transaction_history_card_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true;
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadData(BuildContext context, bool reload) async {}

  @override
  void initState() {
    _loadData(context, true);

    isFirst = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return StreamBuilder<DocumentSnapshot>(
          stream: Get.find<ApiZopay>().getUserStream(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            final user = snapshot.data.data() ?? UserInfoZopay(name: "No Name");
            return Scaffold(
              //backgroundColor: Theme.of(context).canvasColor,
              backgroundColor: ColorResources.getBackgroundColor(),
              appBar: AppBarBase(
                userInfoZopay: user,
              ),
              body: SafeArea(
                  child: Column(
                    children: [
                      FirstCardPortion(userInfoZopay: user,),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE * 2),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Lịch Sử Giao Dịch",
                            style: robotoBold,
                          ),
                        ),
                      ),
                      // SingleChildScrollView(child: ,),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: Get.find<ApiZopay>()
                                .getSendMoneyTransactionHistory(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              final List<TransactionZopay> listTransactions = [
                              ];

                              if (snapshot.hasData &&
                                  snapshot.data.docs != null) {
                                snapshot.data.docs.forEach((element) {
                                  final transaction = element.data();
                                  listTransactions.add(transaction);
                                });
                                listTransactions.sort((transaction,
                                    transaction2) =>
                                    transaction2.completeAt.compareTo(
                                        transaction.completeAt));
                              }
                              return ListView.builder(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: listTransactions.length,
                                  itemBuilder: (context, index) =>
                                      TransactionHistoryCardView(
                                        transaction: listTransactions[index],));
                            }),
                      )
                    ],
                  )),
            );
          });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
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
