import 'package:flutter/material.dart';

abstract class MyColors {
  Color get primaryColor;
  Color get backgroundColor;
  Color get iconColor;
  Color get textColor;
}

class LightColors extends MyColors {
  @override
  Color get primaryColor => const Color.fromARGB(255, 10, 61, 120);  

  @override
  Color get backgroundColor => const Color.fromARGB(255, 240, 240, 240);

  @override
  Color get iconColor => Colors.white;

  @override
  Color get textColor => const Color.fromARGB(255, 10, 61, 120);  
}

class DarkColors extends MyColors {
  @override
  Color get primaryColor => const Color.fromARGB(255, 35, 108, 191);  

  @override
  Color get backgroundColor => const Color.fromARGB(255, 44, 53, 69);

  @override
  Color get iconColor => Colors.white;

  @override
  Color get textColor => Colors.white;
}
