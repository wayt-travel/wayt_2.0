import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../theme/theme.dart';

/// The number of widgets to display in each row of the grid.
const kAddWidgetMbsRowChildrenCount = 4;

/// {@template add_widget_mbs_section}
/// A section in the modal bottom sheet to add a new widget.
///
/// It displays a title and a grid of widgets.
///
/// If there are not enough widgets to fill the grid, it will display
/// placeholders with random colors from the [RandomColor] class.
/// {@endtemplate}
class AddWidgetMbsSection extends StatelessWidget {
  /// The title of the section.
  final String title;

  /// The list of widgets to display in the grid.
  final List<Widget> children;

  /// The index of the first random color to use for the placeholders.
  final int startingRandomColorIndex;

  /// {@macro add_widget_mbs_section}
  const AddWidgetMbsSection({
    required this.title,
    this.children = const [],
    this.startingRandomColorIndex = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.mq.size.width / 6;
    return AddWidgetMbsSectionCustom(
      title: title,
      sliver: SliverGrid.count(
        crossAxisCount: 4,
        crossAxisSpacing: $insets.md,
        mainAxisSpacing: $insets.md,
        children: List.generate(
          ((children.length + kAddWidgetMbsRowChildrenCount) ~/
                  kAddWidgetMbsRowChildrenCount) *
              kAddWidgetMbsRowChildrenCount,
          (i) => children.length > i
              ? children[i]
              : SizedBox.square(
                  dimension: size,
                  child: Placeholder(
                    color: RandomColor.colorFromInt(
                      startingRandomColorIndex + i,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// {@template add_widget_mbs_section_custom}
/// A custom section in the modal bottom sheet to add a new widget.
///
/// It displays a title and a sliver.
/// {@endtemplate}
class AddWidgetMbsSectionCustom extends StatelessWidget {
  /// The title of the section.
  final String title;

  /// The sliver to display in the section.
  final Widget sliver;

  /// {@macro add_widget_mbs_section_custom}
  const AddWidgetMbsSectionCustom({
    required this.title,
    required this.sliver,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        Text(
          title,
          style: context.tt.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).asSliver,
        $insets.xs.asVSpan.asSliver,
        sliver,
        $insets.sm.asVSpan.asSliver,
      ],
    );
  }
}
