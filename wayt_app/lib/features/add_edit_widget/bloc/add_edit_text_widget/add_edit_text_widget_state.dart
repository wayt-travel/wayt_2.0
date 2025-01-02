part of 'add_edit_text_widget_cubit.dart';

final class AddEditTextWidgetState extends SuperBlocState<WError> {
  final FeatureTextStyle featureTextStyle;
  final String? text;

  const AddEditTextWidgetState._({
    required this.featureTextStyle,
    required this.text,
    required super.status,
    super.error,
  });

  const AddEditTextWidgetState.initial({
    required this.featureTextStyle,
    this.text,
  }) : super.initial();

  @override
  AddEditTextWidgetState copyWith({
    required StateStatus status,
    Optional<String?> text = const Optional.absent(),
    FeatureTextStyle? featureTextStyle,
  }) =>
      AddEditTextWidgetState._(
        text: text.orElseIfAbsent(this.text),
        featureTextStyle: featureTextStyle ?? this.featureTextStyle,
        error: error,
        status: status,
      );

  @override
  AddEditTextWidgetState copyWithError(WError error) =>
      AddEditTextWidgetState._(
        text: text,
        featureTextStyle: featureTextStyle,
        error: error,
        status: status,
      );

  @override
  List<Object?> get props => [
        ...super.props,
        featureTextStyle,
        text,
      ];
}
