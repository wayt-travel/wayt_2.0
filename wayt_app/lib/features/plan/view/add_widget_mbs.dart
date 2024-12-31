import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../core/context/context.dart';
import '../../../theme/theme.dart';
import '../../../widgets/modal/modal.dart';

class AddWidgetMbs extends StatelessWidget {
  final ScrollController? scrollController;
  const AddWidgetMbs({super.key, this.scrollController});

  static Future<void> show(BuildContext context) =>
      ModalBottomSheet.of(context).showExpanded(
        builder: (context, scrollController) => SafeArea(
          bottom: false,
          child: AddWidgetMbs(scrollController: scrollController),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: $.style.insets.screenH.asPaddingH,
          sliver: SliverMainAxisGroup(
            slivers: [
              Text(
                'Add widget',
                style: context.tt.titleLarge?.copyWith(
                  fontFamily: kFontFamilySerif,
                ),
              ).asSliver,
              $.style.insets.sm.asVSpan.asSliver,
              Text(
                'Texts',
                style: context.tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).asSliver,
              $.style.insets.xs.asVSpan.asSliver,
              const Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  _AddTextWidgetButton(
                    shortText: 'H1',
                    caption: 'Title 1',
                    fontSize: 34,
                  ),
                  _AddTextWidgetButton(
                    shortText: 'H2',
                    caption: 'Title 2',
                    fontSize: 26,
                  ),
                  _AddTextWidgetButton(
                    shortText: 'H3',
                    caption: 'Title 3',
                    fontSize: 22,
                  ),
                  _AddTextWidgetButton(
                    shortText: '❡',
                    caption: 'Paragraph',
                    fontSize: 16,
                  ),
                ],
              ).asSliver,
            ],
          ),
        ),
      ],
    );
  }
}

class _AddTextWidgetButton extends StatelessWidget {
  final String shortText;
  final String caption;
  final double? fontSize;

  const _AddTextWidgetButton({
    required this.shortText,
    required this.caption,
    required this.fontSize,
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Container(
            width: context.mq.size.width / 6,
            height: context.mq.size.width / 6,
            decoration: BoxDecoration(
              color: context.col.onPrimary,
              borderRadius: $.style.corners.md.asBorderRadius,
            ),
            child: Center(
              child: Text(
                shortText.toUpperCase(),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: kFontFamilySerif,
                  color: context.col.primary,
                ),
              ),
            ),
          ),
          $.style.insets.xs.asVSpan,
          Text(caption),
        ],
      ),
    );
  }
}
