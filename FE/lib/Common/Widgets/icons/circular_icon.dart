import 'package:studio_projects/Utiles/Helpers/helper_functions.dart';
import 'package:studio_projects/Utiles/constants/colors.dart';
import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,

    this.width,
    this.height,
    this.size = MySize.lg,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });


  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor != null ?
            backgroundColor! : 
            HelperFunctions.isDarkMode(context)
            ? MyColors.black.withOpacity(0.9)
            : MyColors.white.withOpacity(0.9),
      ),
      child: IconButton(onPressed:onPressed , icon: Icon(icon,color: color,size: size,)),
    );
  }
}
