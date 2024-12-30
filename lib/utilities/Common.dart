import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Common {
  /// Converts a hex color string (e.g., "#FFFFFF" or "FFFFFF") to a [Color].
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Function to convert HTML string to plain text and limit to a number of lines
  static Widget stringToPlainTextWithLimit(String htmlString, {int maxLines = 2, double fontSize = 14.0}) {
    // Remove HTML tags using a regular expression
    String plainText = _removeHtmlTags(htmlString);

    return Text(
      plainText,
      textAlign: TextAlign.justify, // Align text to be justified
      style: TextStyle(
        fontSize: fontSize, // Set the font size
      ),
      maxLines: maxLines, // Limit to max number of lines
      overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
    );
  }

// Helper function to remove HTML tags
  static String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(exp, '');
  }

  static String formatDate(int timestamp) {
    // Convert timestamp to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Format the DateTime to the desired format
    var formatter = DateFormat("MMM d 'yy");
    return formatter.format(date);
  }
}
