import 'dart:ffi';

import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repositories/repositories.dart';
import '../../../../widgets/modal/modal.dart';
import '../../../../widgets/snack_bar/snack_bar_helper.dart';
import '../../bloc/upsert_text_widget/upsert_text_widget_cubit.dart';
import 'text.dart';

/// Bottom bar for the text widget modal.
/// 
/// It contains buttons to change the text style.
class TextWidgetModalBottomBar extends StatelessWidget {

  /// Creates a new instance of [TextWidgetModalBottomBar].
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
                            .read<UpsertTextWidgetCubit>()
                            .updateTextStyle(
                              outerContext
                                  .read<UpsertTextWidgetCubit>()
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

  @override
  Widget build(BuildContext context) {
    // TODO: use bloc selector instead
    return BlocBuilder<UpsertTextWidgetCubit, UpsertTextWidgetState>(
      builder: (context, state) {
        return BottomAppBar(    
          child: ToggleButtons(
            borderColor: Colors.transparent,
            isSelected: List.filled(5, false),
            onPressed: (index) async {
              if (index == 0) {
                _showFontSizeModal(context);
              } else if (index == 1) {
                await FeatureColorPicker.show(context).then((color) {
                  if (color != null && context.mounted) {
                    context.read<UpsertTextWidgetCubit>().updateTextStyle(
                          context
                              .read<UpsertTextWidgetCubit>()
                              .state
                              .featureTextStyle
                              .copyWith(color: color),
                        );
                  }
                });
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
