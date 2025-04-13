import 'package:equatable/equatable.dart';

/// Parent class for the states of the repositories.
abstract class RepositoryV2State<Entity> extends Equatable {
  const RepositoryV2State();

  @override
  List<Object?> get props => [];
}

class RepoV2InProgressState<Input, Entity> extends RepositoryV2State<Entity> {
  const RepoV2InProgressState(this.input);

  final Input input;

  @override
  List<Object?> get props => [input];

  @override
  String toString() => '$runtimeType { input: $input }';
}

class RepoV2SuccessState<Output, Entity> extends RepositoryV2State<Entity> {
  const RepoV2SuccessState(this.output);

  final Output output;

  @override
  List<Object?> get props => [output];

  @override
  String toString() => '$runtimeType { output: $output }';
}

/// State for when an error occurs.
class RepoV2FailureState<Input, Entity, Err>
    extends RepositoryV2State<Entity> {
  const RepoV2FailureState({
    required this.input,
    required this.error,
  });

  final Input input;
  final Err error;

  @override
  List<Object?> get props => [error, input];

  @override
  String toString() => '$runtimeType { input: $input, error: $error }';
}

/// State for when a collection of items is being fetched.
class RepoV2CollectionFetchInProgress<Entity>
    extends RepositoryV2State<Entity> {
  const RepoV2CollectionFetchInProgress();

  @override
  String toString() => '$runtimeType { }';
}

/// State for when a collection of items is fetched successfully.
class RepoV2CollectionFetchSuccess<Entity> extends RepositoryV2State<Entity> {
  const RepoV2CollectionFetchSuccess(this.items);

  final List<Entity> items;

  @override
  List<Object?> get props => [items];

  @override
  String toString() => '$runtimeType { items: ${items.length} }';
}

/// State for when a collection of items is fetched with an error.
class RepoV2CollectionFetchFailure<Entity, Err>
    extends RepositoryV2State<Entity> {
  const RepoV2CollectionFetchFailure(this.error);

  final Err error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => '$runtimeType { error: $error }';
}

/// State for when an item is being fetched.
class RepoV2ItemFetchInProgress<Id, Entity> extends RepositoryV2State<Entity> {
  final Id id;

  const RepoV2ItemFetchInProgress(this.id);

  @override
  String toString() => '$runtimeType { id: $id }';

  @override
  List<Object?> get props => [id];
}

/// State for when an item is fetched successfully.
class RepoV2ItemFetchSuccess<Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemFetchSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when fetching an item fails.
class RepoV2ItemFetchFailure<Id, Entity, Err>
    extends RepositoryV2State<Entity> {
  const RepoV2ItemFetchFailure({
    required this.id,
    required this.error,
  });

  final Id id;
  final Err error;

  @override
  List<Object?> get props => [error, id];

  @override
  String toString() => '$runtimeType { id: $id, error: $error }';
}

/// State for when an existing item is being added to the repository.
class RepoV2ItemAddInProgress<Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemAddInProgress(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when an existing item is added to the repository successfully.
class RepoV2ItemAddSuccess<Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemAddSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when adding an existing item to the repository fails.
class RepoV2ItemAddFailure<Entity, Err> extends RepositoryV2State<Entity> {
  const RepoV2ItemAddFailure({
    required this.item,
    required this.error,
  });

  final Entity item;
  final Err error;

  @override
  List<Object?> get props => [error, item];

  @override
  String toString() => '$runtimeType { item: $item, error: $error }';
}

/// State for when a new item is being created in the repository.
class RepoV2ItemCreateInProgress<Input, Entity>
    extends RepositoryV2State<Entity> {
  const RepoV2ItemCreateInProgress(this.input);

  final Input input;

  @override
  List<Object?> get props => [input];

  @override
  String toString() => '$runtimeType { input: $input }';
}

/// State for when a new item is created in the repository successfully.
class RepoV2ItemCreateSuccess<Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemCreateSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when creating a new item in the repository fails.
class RepoV2ItemCreateFailure<Input, Entity, Err>
    extends RepositoryV2State<Entity> {
  const RepoV2ItemCreateFailure({
    required this.input,
    required this.error,
  });

  final Input input;
  final Err error;

  @override
  List<Object?> get props => [error, input];

  @override
  String toString() => '$runtimeType { input: $input, error: $error }';
}

/// State for when an item is being deleted from the repository.
class RepoV2ItemDeleteInProgress<Id, Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemDeleteInProgress(this.id);

  final Id id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => '$runtimeType { id: $id }';
}

/// State for when an item is deleted from the repository.
class RepoV2ItemDeleteSuccess<Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemDeleteSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when deleting an item from the repository fails.
class RepoV2ItemDeleteFailure<Id, Entity, Err>
    extends RepositoryV2State<Entity> {
  const RepoV2ItemDeleteFailure({
    required this.id,
    required this.error,
  });

  final Id id;
  final Err error;

  @override
  List<Object?> get props => [error, id];

  @override
  String toString() => '$runtimeType { id: $id, error: $error }';
}

/// State for when an item is updated in the repository.
class RepoV2ItemUpdateInProgress<Id, Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemUpdateInProgress(this.id);

  final Id id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => '$runtimeType { id: $id }';
}

/// State for when an item is updated in the repository.
class RepoV2ItemUpdateSuccess<Entity> extends RepositoryV2State<Entity> {
  const RepoV2ItemUpdateSuccess(this.previous, this.updated);

  final Entity previous;
  final Entity updated;

  @override
  List<Object?> get props => [previous, updated];

  @override
  String toString() =>
      '$runtimeType { previous: $previous, updated: $updated }';
}
