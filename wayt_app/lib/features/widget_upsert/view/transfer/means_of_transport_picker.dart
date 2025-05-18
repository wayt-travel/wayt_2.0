import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../repositories/widget/models/widget_feature/features/means_of_transport/means_of_transport_type.dart';
import '../../../../widgets/modal/modal.dart';

/// {@template means_of_transport_picker}
/// Picker for selecting a means of transport of [MeansOfTransportType].
/// {@endtemplate}
class MeansOfTransportPicker extends StatelessWidget {
  /// The scroll controller for the [CustomScrollView].
  final ScrollController scrollController;

  /// {@macro means_of_transport_picker}
  const MeansOfTransportPicker({required this.scrollController, super.key});

  /// Shows the [MeansOfTransportPicker] as a modal bottom sheet.
  static Future<MeansOfTransportType?> show(BuildContext context) =>
      ModalBottomSheet.of(context).showExpanded<MeansOfTransportType>(
        startExpanded: true,
        builder: (context, scrollController) => MeansOfTransportPicker(
          scrollController: scrollController,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverMainAxisGroup(
            slivers: [
              SliverPadding(
                padding: $insets.screenH.asPaddingH,
                sliver: Text(
                  // FIXME: l10n
                  'Pick a means of transport',
                  style: Theme.of(context).textTheme.titleLarge,
                ).asSliver,
              ),
              $insets.sm.asVSpan.asSliver,
              SliverList.builder(
                itemCount: MeansOfTransportType.values.length,
                itemBuilder: (context, index) {
                  final type = MeansOfTransportType.values[index];
                  return ListTile(
                    onTap: () => context.navRoot.pop(type),
                    leading: Icon(type.icon),
                    title: Text(type.getLocalizedName(context)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
