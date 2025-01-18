import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';

import '../../repositories.dart';

part '_summary_helper_repository_impl.dart';
part 'summary_helper_repository_state.dart';

/// A repository that helps to manage the state of the summary of a plan or a
/// journal by telling for each plan or journal whether it has been fully loaded
/// or not.
abstract interface class SummaryHelperRepository
    extends Repository<TravelDocumentId, bool, SummaryHelperRepositoryState> {
  /// Creates a new instance of [SummaryHelperRepository].
  factory SummaryHelperRepository() => _SummaryHelperRepositoryImpl();

  /// Whether the plan or journal with the given [id] is fully loaded.
  bool isFullyLoaded(TravelDocumentId id);

  /// Sets the plan or journal with the given [id] as fully loaded.
  void setFullyLoaded(TravelDocumentId id);

  /// Unsets the info about the plan or journal with the given [id].
  void unset(TravelDocumentId id);
}
