import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';

import '../../core/context/context.dart';

class LoadingIndicatorMessage extends StatelessWidget {
  const LoadingIndicatorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        $.style.insets.sm.asHSpan,
        // FIXME: l10n
        const Text('Loading...'),
      ],
    );
  }
}
