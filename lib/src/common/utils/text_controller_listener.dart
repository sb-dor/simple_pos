import 'package:flutter/material.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';

typedef TextControllerListenerRules = Map<String, bool Function(String value)>;

class TextControllerListener extends ChangeNotifier {
  TextControllerListener(
    this._textEditingController, {

    /// See [_rules] for detailed documentation on how rules work.
    final TextControllerListenerRules? rules,
  }) : _rules = rules ?? {} {
    _textEditingController.addListener(_textListener);
  }

  final TextEditingController _textEditingController;

  /// A map of validation rules applied to the text controller.
  ///
  /// **Rule order matters:**
  ///
  /// Always define higher-priority rules first.
  /// For example, if you need to ensure the field is not empty **before**
  /// checking its length, place the “cannot be empty” rule first.
  ///
  /// **Example:**
  /// ```dart
  /// rules: {
  ///   fieldCannotBeEmpty: (value) => value.trim().isNotEmpty,
  ///   descriptionMustContainAtLeast15Characters: (value) => value.trim().length >= 15,
  /// },
  /// ```
  ///
  /// - **Key** — The message shown when the rule fails.
  /// - **Value** — A validation function that receives the current
  ///   controller text and returns `true` (valid) or `false` (invalid).
  ///
  /// To retrieve the current error message, use the [error] getter.
  final TextControllerListenerRules _rules;

  String? _error;

  String? get error => _error;

  bool get validated {
    _textListener();
    return _error == null;
  }

  int get length => _textEditingController.text.trim().length;

  String get trimmedText => _textEditingController.text.trim();

  void _textListener() {
    if (_rules.isNotEmpty) {
      bool anyInvalid = false;
      for (final rule in _rules.entries) {
        final valid = rule.value.call(trimmedText);
        if (!valid) {
          anyInvalid = true;
          _error = rule.key;
          break;
        }
      }
      if (!anyInvalid) _error = null;
    } else {
      if (_textEditingController.text.trim().isEmpty) {
        _error = Constants.fieldCannotBeEmpty;
      } else {
        _error = null;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textListener);
    super.dispose();
  }
}
