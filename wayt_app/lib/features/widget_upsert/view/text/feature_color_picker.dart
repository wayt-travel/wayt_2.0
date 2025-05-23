import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../../core/context/context.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/modal/modal.dart';

/// {@template feature_color_picker}
/// Picker for selecting a color of [FeatureColor] type.
/// {@endtemplate}
class FeatureColorPicker extends StatelessWidget {
  /// The scroll controller for the [CustomScrollView].
  final ScrollController scrollController;

  /// {@macro feature_color_picker}
  const FeatureColorPicker({required this.scrollController, super.key});

  /// Shows the [FeatureColorPicker] as a modal bottom sheet.
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
            padding: $insets.screenH.asPaddingH,
            // FIXME: l10n
            sliver: SliverMainAxisGroup(
              slivers: [
                Text(
                  'Pick a color',
                  style: context.tt.titleLarge,
                ).asSliver,
                $insets.sm.asVSpan.asSliver,
                SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: $insets.xs,
                    mainAxisSpacing: $insets.xs,
                  ),
                  itemCount: FeatureColor.values.length,
                  itemBuilder: (context, index) {
                    final color = FeatureColor.values[index];
                    return InkWell(
                      onTap: () => context.navRoot.pop(color),
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: $.style.corners.card.asBorderRadius,
                        ),
                        clipBehavior: Clip.hardEdge,
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
