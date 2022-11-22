import 'package:flutter/material.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../../../../../util/color_resources.dart';
import '../../../../../../util/dimensions.dart';

class ContactTile extends StatelessWidget {
  final int index;

  const ContactTile({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child:
                  // CircleAvatar(backgroundImage: MemoryImage(transactionMoneyController.filterdContacts[index].contact.thumbnail)) :
                  // transactionMoneyController.filterdContacts[index].contact.displayName == '' ?
                  CircleAvatar()
              // CircleAvatar(child:  Text(transactionMoneyController.filterdContacts[index].contact.displayName[0].toUpperCase())),
              ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Khánh",
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
              Text(
                "0394998716",
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    color: ColorResources.getGreyBaseGray1()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
