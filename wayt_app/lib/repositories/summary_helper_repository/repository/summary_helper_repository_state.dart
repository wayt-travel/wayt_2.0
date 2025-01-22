part of 'summary_helper_repository.dart';

/// Parent class for the states of the repositories.
sealed class SummaryHelperRepositoryState extends RepositoryState<void>
    with EquatableMixin {
  const SummaryHelperRepositoryState();
}

/// State for when a repository item changes.
class SummaryHelperRepositoryChanged extends SummaryHelperRepositoryState {
  final TravelDocumentId id;
  final bool isFullyLoaded;

  const SummaryHelperRepositoryChanged({
    required this.id,
    required this.isFullyLoaded,
  });

  @override
  List<Object?> get props => [id, isFullyLoaded];
}
