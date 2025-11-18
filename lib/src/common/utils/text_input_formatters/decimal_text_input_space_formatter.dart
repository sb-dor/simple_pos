import 'package:flutter/services.dart';
import 'package:test_pos_app/src/common/utils/reusable_functions.dart';

class DecimalTextInputSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll(' ', '');

    final regEx = RegExp(r'^\d*\.?\d{0,2}$');
    if (!regEx.hasMatch(rawText)) {
      return oldValue;
    }

    final parts = rawText.split('.');
    final intPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : null;

    final formattedIntPart = ReusableFunctions.instance.separateNumbersRegex(int.tryParse(intPart));

    String formattedText = formattedIntPart ?? '';
    if (decimalPart != null) {
      formattedText += '.$decimalPart';
    }

    final diff = formattedText.length - newValue.text.length;
    final newOffset = (newValue.selection.end + diff).clamp(0, formattedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
