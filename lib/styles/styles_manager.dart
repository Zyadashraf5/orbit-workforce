import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../colors/colors.dart';

class AppTextStyle {
  // Montserrat Light Fonts
  static TextStyle montserratLight = const TextStyle(
    fontWeight: FontWeight.w300,
    color: ThemeColors.black,
    fontSize: 16,
    fontFamily: 'Cairo',
  );
  // Montserrat Regular Fonts
  static TextStyle montserraRegular = const TextStyle(
    fontWeight: FontWeight.w400,
    color: ThemeColors.black,
    fontSize: 16,
    fontFamily: 'Cairo',
  );
  // Montserrat SemiBold Fonts
  static TextStyle montserraSemiBold = const TextStyle(
    fontWeight: FontWeight.w600,
    color: ThemeColors.black,
    fontSize: 16,
    fontFamily: 'Cairo',
  );
  // Montserrat Bold Fonts
  static TextStyle montserraBold = const TextStyle(
    fontWeight: FontWeight.w700,
    color: ThemeColors.black,
    fontSize: 16,
    fontFamily: 'Cairo',
  );
  // Montserrat Black Fonts
  static TextStyle montserraBlack = const TextStyle(
    fontWeight: FontWeight.w900,
    color: ThemeColors.black,
    fontSize: 16,
    fontFamily: 'Cairo',
  );

  static TextStyle montserragray = TextStyle(
    fontWeight: FontWeight.w400,
    color: HexColor('#616161'),
    fontSize: 14,
    fontFamily: 'Cairo',
  );
}
