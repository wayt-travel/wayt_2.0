import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core.dart';
import '../../../../../repositories/repositories.dart';
import '../../../../../widgets/widgets.dart';

/// {@template geo_feature_picker}
/// A picker for selecting a geo feature, either from existing travel widgets
/// or by manually entering geo coordinates.
/// {@endtemplate}
class GeoFeaturePicker extends StatelessWidget {
  /// The scroll controller for the [CustomScrollView].
  final ScrollController scrollController;

  /// The travel document wrapper.
  ///
  /// It is used to get the list of geo features from the travel document.
  final TravelDocumentWrapper travelDocumentWrapper;

  /// The list of geo features available in the travel document.
  final List<GeoWidgetFeatureEntity> geoFeatures;

  /// {@macro geo_feature_picker}
  const GeoFeaturePicker._({
    required this.scrollController,
    required this.travelDocumentWrapper,
    required this.geoFeatures,
  });

  /// Shows the [GeoFeaturePicker] as a modal bottom sheet.
  static Future<GeoWidgetFeatureEntity?> show(
    BuildContext context, {
    required TravelDocumentEntity travelDocument,
  }) {
    final travelDocumentWrapper = TravelDocumentWrapper(
      travelDocument: travelDocument,
      travelItems: $.repo.travelItem().getAllOf(travelDocument.tid),
    );
    return ModalBottomSheet.of(context).showExpanded<GeoWidgetFeatureEntity>(
      startExpanded: true,
      builder: (context, scrollController) => GeoFeaturePicker._(
        scrollController: scrollController,
        travelDocumentWrapper: travelDocumentWrapper,
        geoFeatures: travelDocumentWrapper.allFeatures
            .whereType<GeoWidgetFeatureEntity>()
            .where((geo) => geo.name?.isNotEmpty ?? false)
            .toList(),
      ),
    );
  }

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
                  'Pick a Place from your Travel',
                  style: Theme.of(context).textTheme.titleLarge,
                ).asSliver,
              ),
              $insets.sm.asVSpan.asSliver,
              if (geoFeatures.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: $insets.screenH.asPaddingH.copyWith(
                      top: $insets.md,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          // FIXME: l10n
                          'There are no places in your travel yet.',
                        ),
                        $insets.xs.asVSpan,
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: geoFeatures.length,
                  itemBuilder: (context, index) {
                    final geo = geoFeatures[index];
                    return ListTile(
                      onTap: () => context.navRoot.pop(geo),
                      leading: const Icon(Icons.place),
                      title: Text(geo.name!),
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
