import 'package:studio_projects/Utiles/constants/size.dart';
import 'package:flutter/material.dart';

class spaceingStyle{
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: MySize.appBarHeight,
    left: MySize.defaultSpace,
    right: MySize.defaultSpace,
    bottom: MySize.defaultSpace,
  );
}