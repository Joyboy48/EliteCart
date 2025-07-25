import 'package:studio_projects/Common/Widgets/images/circular_images.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class userProfileTile extends StatelessWidget {
  const userProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircularImage(image: ImageStrings.userImage1,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text('Astitva Arya',style: Theme.of(context).textTheme.headlineSmall!.apply(color: MyColors.white),),
      subtitle: Text('qwerty1234@gmail.com',style: Theme.of(context).textTheme.bodyMedium!.apply(color: MyColors.white),),
      trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit,color: MyColors.white,)),
    );
  }
}