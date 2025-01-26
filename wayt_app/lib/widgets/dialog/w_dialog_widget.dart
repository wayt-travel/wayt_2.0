import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../core/context/context.dart';

@Deprecated(
  'Not supposed to be used anymore. Too much customizations. Use default '
  'AlertDialog instead.',
)
class WAlertDialogBody extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @Deprecated(
    'Not supposed to be used anymore. Too much customizations. Use default '
    'AlertDialog instead.',
  )
  const WAlertDialogBody({
    required this.title,
    required this.actions,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final showSubtitle = subtitle?.isNotEmpty ?? false;
    return AlertDialog(
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints(
              minHeight: 100,
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              showSubtitle ? 26 : 20,
              16,
              12,
            ),
            child: MediaQuery(
              data: context.mq.copyWith(textScaler: TextScaler.noScaling),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                    ),
                    if (showSubtitle) ...[
                      $insets.sm.asVSpan,
                      Text(
                        subtitle!,
                        style: context.tt.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions,
              ),
            ),
        ],
      ),
    );
  }
}
