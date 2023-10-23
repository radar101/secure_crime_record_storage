import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  final double width;
  final Color darkYellow = Colors.yellow.shade400;
  final Color lightYellow = Colors.yellow.shade100;
  final Color yellow = Colors.yellow;
  late final TextStyle eventTitleStyle;
  late final TextStyle eventDescriptionStyle;
  late final TextStyle smallTextStyle;
  late final TextStyle eventCorordinatorsStyle;

  TextStyles({required BuildContext context})
      : width = MediaQuery.of(context).size.width {
    initializeStyles();
  }

  TextStyle medText = TextStyle();

  void initializeStyles() {
    medText = GoogleFonts.poppins(
        color: darkYellow,
        textStyle: TextStyle(
          fontSize: width * 0.05,
        ));
  }
}
