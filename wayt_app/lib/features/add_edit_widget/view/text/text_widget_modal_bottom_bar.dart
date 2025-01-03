import 'dart:ffi';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/context/context.dart';
import '../../../../repositories/repositories.dart';
import '../../../../widgets/modal/modal.dart';
import '../../../../widgets/snack_bar/snack_bar_helper.dart';
import '../../bloc/add_edit_text_widget/add_edit_text_widget_cubit.dart';
import 'scales/text_widget_scale_button.dart';
import 'scales/text_widget_scale_icon.dart';

class TextWidgetModalBottomBar extends StatelessWidget {
  const TextWidgetModalBottomBar({super.key});

  void _showFontSizeModal(BuildContext outerContext) =>
      ModalBottomSheet.of(outerContext).showShrunk<Void>(
        childrenBuilder: (context) => [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: FeatureTextStyleScale.values
                  .map(
                    (scale) => TextWidgetScaleButton(
                      scale: scale,
                      size: context.mq.size.width / 6,
                      onTap: (context) {
                        outerContext
                            .read<AddEditTextWidgetCubit>()
                            .updateTextStyle(
                              outerContext
                                  .read<AddEditTextWidgetCubit>()
                                  .state
                                  .featureTextStyle
                                  .copyWith(scale: scale),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );

  void _showFontColorModal(BuildContext outerContext) =>
      ModalBottomSheet.of(outerContext).showExpanded<Void>(
        builder: (context, scrollController) => SafeArea(
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
                      itemCount: FeatureTextStyleColor.values.length,
                      itemBuilder: (context, index) {
                        final color = FeatureTextStyleColor.values[index];
                        return InkWell(
                          onTap: () {
                            outerContext
                                .read<AddEditTextWidgetCubit>()
                                .updateTextStyle(
                                  outerContext
                                      .read<AddEditTextWidgetCubit>()
                                      .state
                                      .featureTextStyle
                                      .copyWith(color: color),
                                );
                            context.navRoot.pop();
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
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: use bloc selector instead
    return BlocBuilder<AddEditTextWidgetCubit, AddEditTextWidgetState>(
      builder: (context, state) {
        return BottomAppBar(
          child: ToggleButtons(
            borderColor: Colors.transparent,
            isSelected: List.filled(5, false),
            onPressed: (index) {
              if (index == 0) {
                _showFontSizeModal(context);
              } else if (index == 1) {
                _showFontColorModal(context);
              } else {
                SnackBarHelper.I.showNotImplemented(context);
              }
            },
            children: [
              TextWidgetScaleIcon(
                size: 36,
                scale: state.featureTextStyle.scale,
              ),
              Icon(
                Icons.format_color_text,
                color: state.featureTextStyle.color?.toFlutterColor(context) ??
                    context.col.onSurface,
              ),
              const Icon(Icons.format_bold),
              const Icon(Icons.format_italic),
              const Icon(Icons.format_underlined),
            ],
          ),
        );
      },
    );
  }
}
