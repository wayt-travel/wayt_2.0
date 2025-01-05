import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../theme/theme.dart';
import '../../../widgets/modal/modal.dart';
import 'text/scales/text_widget_scale_button.dart';
import 'text/text_widget_modal.dart';

class AddWidgetMbs extends StatelessWidget {
  final PlanOrJournalId id;
  final int? index;
  final ScrollController? scrollController;
  
  const AddWidgetMbs({
    required this.id,
    required this.index,
    super.key,
    this.scrollController,
  });

  static Future<void> show(
    BuildContext context, {
    required PlanOrJournalId id,
    required int? index,
  }) =>
      ModalBottomSheet.of(context).showExpanded(
        builder: (context, scrollController) => SafeArea(
          bottom: false,
          child: AddWidgetMbs(
            scrollController: scrollController,
            index: index,
            id: id,
          ),
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
                // FIXME: l10n
                'Add widget',
                style: context.tt.titleLarge?.copyWith(
                  fontFamily: kFontFamilySerif,
                ),
              ).asSliver,
              $.style.insets.sm.asVSpan.asSliver,
              Text(
                // FIXME: l10n
                'Texts',
                style: context.tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).asSliver,
              $.style.insets.xs.asVSpan.asSliver,
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: FeatureTextStyleScale.values
                    .map(
                      (scale) => TextWidgetScaleButton(
                        scale: scale,
                        size: context.mq.size.width / 6,
                        onTap: (context) {
                          context.navRoot.pop();
                          TextWidgetModal.show(
                            context: context,
                            id: id,
                            index: index,
                            style: scale,
                          );
                        },
                      ),
                    )
                    .toList(),
              ).asSliver,
            ],
          ),
        ),
      ],
    );
  }
}
