import 'package:flutter/material.dart';

import '../../../../../../util/dimensions.dart';
import 'history_shimmer.dart';
import 'transaction_history_card_view.dart';

class TransactionViewScreen extends StatelessWidget {
  final ScrollController scrollController;
  final bool isHome;
  final String type;

  const TransactionViewScreen(
      {Key key, this.scrollController, this.isHome, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 0,
              itemBuilder: (ctx, index) {
                return Container(child: TransactionHistoryCardView());
              }),
        ),
        // NoDataFoundScreen(fromHome: isHome),
        HistoryShimmer(),
        Center(
            child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor)),
        )),
        // SizedBox.shrink(),
      ],
    );
  }
}
