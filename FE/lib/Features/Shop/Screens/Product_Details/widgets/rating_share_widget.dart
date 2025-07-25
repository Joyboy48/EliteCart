import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RatingandShare extends StatelessWidget {
  final dynamic product;
  final double avgRating;
  final int reviewCount;
  const RatingandShare(
      {super.key,
      required this.product,
      required this.avgRating,
      required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    final rating = avgRating.toStringAsFixed(1);
    final reviewCountStr = reviewCount.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///Rating
        Row(
          children: [
            const Icon(Iconsax.star5, color: Colors.amber, size: 24),
            const SizedBox(width: MySize.spaceBtwItems),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: rating,
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(text: ' ($reviewCountStr)'),
                ],
              ),
            ),
          ],
        ),

        ///ShareButton
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, size: MySize.iconMd)),
      ],
    );
  }
}
