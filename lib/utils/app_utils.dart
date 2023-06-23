import 'package:flutter/material.dart';

class AppUtils {
  static void showInfoMessage(String messageText, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messageText, textAlign: TextAlign.center)));

  static void switchScreen(Widget screen, BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

  static void switchScreenWithoutReturn(Widget screen, BuildContext context) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
}
