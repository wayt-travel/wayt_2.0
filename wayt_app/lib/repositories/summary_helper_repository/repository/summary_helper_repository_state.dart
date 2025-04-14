part of 'summary_helper_repository.dart';

/// Parent class for the states of the repositories.
sealed class SummaryHelperRepositoryState extends RepositoryState<void>
    with EquatableMixin {
  const SummaryHelperRepositoryState();
}

/// {@template summary_helper_repository_changed}
/// State for when a repository item changes.
/// {@endtemplate}
class SummaryHelperRepositoryChanged extends SummaryHelperRepositoryState {
  /// The id of the travel document.
  final TravelDocumentId id;

  /// Whether the travel document is fully loaded, i.e., all its travel items
  /// are loaded.
  final bool isFullyLoaded;

  /// {@macro summary_helper_repository_changed}
  const SummaryHelperRepositoryChanged({
    required this.id,
    required this.isFullyLoaded,
  });

  @override
  List<Object?> get props => [id, isFullyLoaded];
}
