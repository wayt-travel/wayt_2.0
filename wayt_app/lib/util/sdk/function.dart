import 'package:flutter/material.dart';

/// Unfocuses the current focus node.
void unfocus(BuildContext context) {
  final currentScope = FocusScope.of(context);
  if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
