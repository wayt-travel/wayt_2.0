import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../../core/context/context.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/modal/modal.dart';

/// Picker for selecting a color of [FeatureColor] type.
class FeatureColorPicker extends StatelessWidget {
  final ScrollController scrollController;
  const FeatureColorPicker({required this.scrollController, super.key});

  static Future<FeatureColor?> show(BuildContext context) =>
      ModalBottomSheet.of(context).showExpanded<FeatureColor>(
        startExpanded: true,
        builder: (context, scrollController) => FeatureColorPicker(
          scrollController: scrollController,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: $.style.insets.screenH.asPaddingH,
            // FIXME: l10n
            sliver: SliverMainAxisGroup(
              slivers: [
                Text(
                  'Pick a color',
                  style: context.tt.titleLarge,
                ).asSliver,
                $.style.insets.sm.asVSpan.asSliver,
                SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: $.style.insets.xs,
                    mainAxisSpacing: $.style.insets.xs,
                  ),
                  itemCount: FeatureColor.values.length,
                  itemBuilder: (context, index) {
                    final color = FeatureColor.values[index];
                    return InkWell(
                      onTap: () {
                        context.navRoot.pop(color);
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: $.style.corners.card.asBorderRadius,
                        ),
                        color: color.toFlutterColor(context),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
