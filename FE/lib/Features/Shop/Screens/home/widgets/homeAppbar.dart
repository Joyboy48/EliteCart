import 'package:studio_projects/Common/Widgets/appBar/appBar.dart';
import 'package:studio_projects/Common/Widgets/products/cart/cart_menu_icon.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/texts_strings.dart';
import 'package:flutter/material.dart';

class homeAppbar extends StatelessWidget {
  final String? userName;
  const homeAppbar({
    super.key,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return MyAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextsStrings.homeAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: MyColors.grey),
          ),
          Text(
            userName != null && userName!.isNotEmpty
                ? userName!
                : TextsStrings.homeAppBarSubTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: MyColors.white),
          ),
        ],
      ),
      actions: [
        cartCounterIcon(
          onPressed: () {},
          iconColor: MyColors.white,
        )
      ],
    );
  }
}
