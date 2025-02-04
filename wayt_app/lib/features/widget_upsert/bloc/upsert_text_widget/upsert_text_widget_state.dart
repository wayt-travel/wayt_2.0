part of 'upsert_text_widget_cubit.dart';

final class UpsertTextWidgetState extends SuperBlocState<WError> {
  /// The text style of the widget.
  final TypographyFeatureStyle featureTextStyle;

  /// The text of the widget.
  final String? text;

  const UpsertTextWidgetState._({
    required this.featureTextStyle,
    required this.text,
    required super.status,
    super.error,
  });

  const UpsertTextWidgetState.initial({
    required this.featureTextStyle,
    this.text,
  }) : super.initial();

  @override
  UpsertTextWidgetState copyWith({
    required StateStatus status,
    Optional<String?> text = const Optional.absent(),
    TypographyFeatureStyle? featureTextStyle,
  }) =>
      UpsertTextWidgetState._(
        text: text.orElseIfAbsent(this.text),
        featureTextStyle: featureTextStyle ?? this.featureTextStyle,
        error: error,
        status: status,
      );

  @override
  UpsertTextWidgetState copyWithError(WError error) => UpsertTextWidgetState._(
        text: text,
        featureTextStyle: featureTextStyle,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        featureTextStyle,
        text,
      ];
}
