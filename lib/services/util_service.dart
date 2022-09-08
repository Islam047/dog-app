import 'package:flutter/material.dart';

class Util {
  // FireSnackBar
  static fireSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade400.withOpacity(0.975),
        content: Text(msg, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
        duration: const Duration(milliseconds: 2500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
    );
  }
}