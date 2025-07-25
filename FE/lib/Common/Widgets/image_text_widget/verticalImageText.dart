import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class verticalImageText extends StatelessWidget {
  const verticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.background,
    this.onTap,
    this.textColor = MyColors.white,
  });

  final String image, title;
  final Color textColor;
  final Color? background;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: MySize.spaceBtwItems),
        child: Column(
          children: [
            //circular icon
            Container(
              height: 56,
              width: 56,
              padding: const EdgeInsets.all(MySize.sm),
              decoration: BoxDecoration(
                  color: background ?? (dark ? MyColors.dark : MyColors.white),
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: image.startsWith('http')
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        image,
                        fit: BoxFit.cover,
                        color: (dark ? MyColors.white : MyColors.dark),
                      ),
              ),
            ),
            //text
            const SizedBox(
              height: MySize.spaceBtwItems / 2,
            ),
            SizedBox(
                width: 55,
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }
}
