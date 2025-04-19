import 'package:equatable/equatable.dart';

/// Parent class for the states of the repositories.
abstract class RepositoryV3State<Entity> extends Equatable {
  const RepositoryV3State();

  @override
  List<Object?> get props => [];
}

/// State for when a collection of items is being fetched.
class RepoV3CollectionFetchInProgress<Entity>
    extends RepositoryV3State<Entity> {
  const RepoV3CollectionFetchInProgress();

  @override
  String toString() => '$runtimeType { }';
}

/// State for when a collection of items is fetched successfully.
class RepoV3CollectionFetchSuccess<Entity> extends RepositoryV3State<Entity> {
  const RepoV3CollectionFetchSuccess(this.items);

  final List<Entity> items;

  @override
  List<Object?> get props => [items];

  @override
  String toString() => '$runtimeType { items: ${items.length} }';
}

/// State for when a collection of items is fetched with an error.
class RepoV3CollectionFetchFailure<Entity, Err>
    extends RepositoryV3State<Entity> {
  const RepoV3CollectionFetchFailure(this.error);

  final Err error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => '$runtimeType { error: $error }';
}

/// State for when an item is being fetched.
class RepoV3ItemFetchInProgress<Id, Entity> extends RepositoryV3State<Entity> {
  final Id id;

  const RepoV3ItemFetchInProgress(this.id);

  @override
  String toString() => '$runtimeType { id: $id }';

  @override
  List<Object?> get props => [id];
}

/// State for when an item is fetched successfully.
class RepoV3ItemFetchSuccess<Entity> extends RepositoryV3State<Entity> {
  const RepoV3ItemFetchSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when fetching an item fails.
class RepoV3ItemFetchFailure<Id, Entity, Err>
    extends RepositoryV3State<Entity> {
  const RepoV3ItemFetchFailure({
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
class RepoV3ItemAddInProgress<Entity> extends RepositoryV3State<Entity> {
  const RepoV3ItemAddInProgress(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when an existing item is added to the repository successfully.
class RepoV3ItemAddSuccess<Entity> extends RepositoryV3State<Entity> {
  const RepoV3ItemAddSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when adding an existing item to the repository fails.
class RepoV3ItemAddFailure<Entity, Err> extends RepositoryV3State<Entity> {
  const RepoV3ItemAddFailure({
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
class RepoV3ItemCreateInProgress<Input, Entity>
    extends RepositoryV3State<Entity> {
  const RepoV3ItemCreateInProgress(this.input);

  final Input input;

  @override
  List<Object?> get props => [input];

  @override
  String toString() => '$runtimeType { input: $input }';
}

/// State for when a new item is created in the repository successfully.
class RepoV3ItemCreateSuccess<Entity> extends RepositoryV3State<Entity> {
  const RepoV3ItemCreateSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when creating a new item in the repository fails.
class RepoV3ItemCreateFailure<Input, Entity, Err>
    extends RepositoryV3State<Entity> {
  const RepoV3ItemCreateFailure({
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
class RepoV3ItemDeleteInProgress<Id, Entity> extends RepositoryV3State<Entity> {
  const RepoV3ItemDeleteInProgress(this.id);

  final Id id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => '$runtimeType { id: $id }';
}

/// State for when an item is deleted from the repository.
class RepoV3ItemDeleteSuccess<Entity> extends RepositoryV3State<Entity> {
  const RepoV3ItemDeleteSuccess(this.item);

  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when deleting an item from the repository fails.
class RepoV3ItemDeleteFailure<Id, Entity, Err>
    extends RepositoryV3State<Entity> {
  const RepoV3ItemDeleteFailure({
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
class RepoV3ItemUpdateInProgress<Id, Entity> extends RepositoryV3State<Entity> {
  const RepoV3ItemUpdateInProgress(this.id);

  final Id id;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => '$runtimeType { id: $id }';
}

/// State for when an item is updated in the repository.
class RepoV3ItemUpdateSuccess<Output, Entity>
    extends RepositoryV3State<Entity> {
  const RepoV3ItemUpdateSuccess(this.previous, this.updated);

  final Output previous;
  final Output updated;

  @override
  List<Object?> get props => [previous, updated];

  @override
  String toString() =>
      '$runtimeType { previous: $previous, updated: $updated }';
}
