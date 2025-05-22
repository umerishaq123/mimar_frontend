import 'package:flutter/material.dart';


class SnackbarUtils {
  static void showCustomSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    Color backgroundColor = Colors.blue,
    Color textColor = Colors.white,
    IconData icon = Icons.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                Text(message, style: TextStyle(color: textColor)),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
