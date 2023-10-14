

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Format the phone number with spaces for better readability
    if (newValue.text.isNotEmpty) {
      final formattedText = newValue.text;
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
    return newValue;
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField(this.titleText, this.textType);
  final String? titleText;
  final TextInputType? textType;
  TextField textFieldIn = TextField();
  TextEditingController editController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    textFieldIn = TextField(
      controller: editController,
      textCapitalization: textType == TextInputType.name ? TextCapitalization.words : TextCapitalization.none,
      keyboardType: textType,
      inputFormatters: (textType == TextInputType.phone) ? [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(10), // Limit to 10 digits
        _PhoneNumberFormatter(), // Custom formatter for phone numbers
      ] : [],
      decoration: InputDecoration(
        labelText: titleText
      ),
    );
    return Expanded(
      child: textFieldIn,
    );
  }
}