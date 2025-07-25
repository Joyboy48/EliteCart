import 'package:studio_projects/Utiles/theme/custom_themes/app_bar_theme.dart';
import 'package:studio_projects/Utiles/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:studio_projects/Utiles/theme/custom_themes/checkbox_theme.dart';
import 'package:studio_projects/Utiles/theme/custom_themes/chip_theme.dart';
import 'package:studio_projects/Utiles/theme/custom_themes/elevated_button_theme.dart';
import 'package:studio_projects/Utiles/theme/custom_themes/outline_button_theme.dart';
import 'package:studio_projects/Utiles/theme/custom_themes/text_field_theme.dart';
import 'package:studio_projects/Utiles/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lighttheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    chipTheme: TChipTheme.lightChipTheme,
    outlinedButtonTheme: TOutlineButtonTheme.lightOutlineButtontheme,
    inputDecorationTheme: TTextFormFieldTheme.lightIputDecorationTheme,
  );
  static ThemeData darktheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF181A20),
    cardColor: Color(0xFF232323),
    dividerColor: Colors.white24,
    dialogBackgroundColor: Color(0xFF232323),
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    chipTheme: TChipTheme.darkChipTheme,
    outlinedButtonTheme: TOutlineButtonTheme.darkOutlineButtontheme,
    inputDecorationTheme: TTextFormFieldTheme.darkIputDecorationTheme,
  );
}
