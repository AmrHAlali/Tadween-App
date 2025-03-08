import 'package:flutter/material.dart';
import 'package:tadween_app/core/theme/colors.dart';

class MyTheme {
  final MyColors colors;

  MyTheme({required this.colors});

  ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: colors.backgroundColor,

    progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.primaryColor),

    appBarTheme: AppBarTheme(
      color: colors.primaryColor,
      centerTitle: true,
      iconTheme: IconThemeData(color: colors.iconColor, size: 40),
    ),

    dividerTheme: DividerThemeData(color: colors.primaryColor, thickness: 1.25),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: CircleBorder(),
      backgroundColor: colors.primaryColor,
      foregroundColor: Colors.white,
      sizeConstraints: BoxConstraints.tightFor(width: 65, height: 65),
      iconSize: 40,
    ),

    iconTheme: IconThemeData(color: colors.primaryColor),

    listTileTheme: ListTileThemeData(
      iconColor: colors.textColor,
      textColor: colors.textColor,
      titleTextStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: colors.iconColor,
      ),

      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: colors.textColor,
      ),

      bodyMedium: TextStyle(fontSize: 12, color: colors.textColor),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primaryColor,
        textStyle: TextStyle(color: Colors.white),
        iconColor: Colors.white,
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.backgroundColor,
    ),

    dialogTheme: DialogTheme(
      backgroundColor: colors.backgroundColor,
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colors.textColor),
      contentTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: colors.textColor),
    ),

    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: colors.primaryColor, width: 3.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: colors.primaryColor, width: 3.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: colors.primaryColor, width: 3.0),
      ),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.backgroundColor),
      ),
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: colors.backgroundColor,
    ),

    bottomAppBarTheme: BottomAppBarTheme(
      color: colors.primaryColor,
      height: 70,
    ),
  );
}

class LightTheme extends MyTheme {
  LightTheme() : super(colors: LightColors());
}

class DarkTheme extends MyTheme {
  DarkTheme() : super(colors: DarkColors());
}
