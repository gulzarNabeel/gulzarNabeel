

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

class PhoneNumberTextField extends StatelessWidget {
  TextField textFieldPhone = TextField(
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      LengthLimitingTextInputFormatter(10), // Limit to 10 digits
      _PhoneNumberFormatter(), // Custom formatter for phone numbers
    ],
    decoration: InputDecoration(
      labelText: 'Phone Number',
      hintText: 'Phone Number',
    ),
  );
  TextEditingController editController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    textFieldPhone = TextField(
      controller: editController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(10), // Limit to 10 digits
        _PhoneNumberFormatter(), // Custom formatter for phone numbers
      ],
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Phone Number',
      ),
    );
    return Expanded(
      child: textFieldPhone,
    );
  }
}