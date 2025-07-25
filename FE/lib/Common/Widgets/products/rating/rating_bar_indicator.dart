import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

class MyRatingBarIndicator extends StatelessWidget {
  const MyRatingBarIndicator({
    super.key, required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(itemBuilder: (_,__)=> const  Icon(Iconsax.star1,color: MyColors.primary,),
      itemCount: 5,
      rating: rating,
      itemSize: 20,
      unratedColor: MyColors.grey,
    );
  }
}