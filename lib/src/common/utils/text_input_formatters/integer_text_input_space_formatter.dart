import 'package:flutter/services.dart';
import 'package:test_pos_app/src/common/utils/reusable_functions.dart';

/// A [TextInputFormatter] for integers that:
/// - allows only digits (no decimals or negative signs)
/// - adds thousands separators automatically (e.g. `1 000 000`)
class IntegerTextInputSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // remove all spaces first to get the raw numeric input
    final rawText = newValue.text.replaceAll(' ', '');

    // validate — only digits allowed
    final regEx = RegExp(r'^\d*$');
    if (!regEx.hasMatch(rawText)) {
      return oldValue;
    }

    // format with grouping (using your existing global function)
    final formattedText =
        ReusableFunctions.instance.separateNumbersRegex(int.tryParse(rawText)) ?? '';

    // adjust the cursor position
    final diff = formattedText.length - newValue.text.length;
    final newOffset = (newValue.selection.end + diff).clamp(0, formattedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
