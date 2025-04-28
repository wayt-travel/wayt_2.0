import 'package:equatable/equatable.dart';

import 'repository_v3.dart';

/// Parent class for the states of [RepositoryV3] implementations.
abstract class RepositoryV3State<Entity> extends Equatable {
  /// Creates a new instance of [RepositoryV3State].
  const RepositoryV3State();

  @override
  List<Object?> get props => [];
}

/// State for when a collection of items is fetched successfully.
class RepoV3CollectionFetchSuccess<Entity> extends RepositoryV3State<Entity> {
  /// Creates a new instance of [RepoV3CollectionFetchSuccess].
  const RepoV3CollectionFetchSuccess(this.items);

  /// The list of items fetched from the repository.
  final List<Entity> items;

  @override
  List<Object?> get props => [items];

  @override
  String toString() => '$runtimeType { items: ${items.length} }';
}

/// State for when an item is fetched successfully.
class RepoV3ItemFetchSuccess<Entity> extends RepositoryV3State<Entity> {
  /// Creates a new instance of [RepoV3ItemFetchSuccess].
  const RepoV3ItemFetchSuccess(this.item);

  /// The item fetched from the repository.
  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when an existing item is added to the repository successfully.
class RepoV3ItemAddSuccess<Entity> extends RepositoryV3State<Entity> {
  /// Creates a new instance of [RepoV3ItemAddSuccess].
  const RepoV3ItemAddSuccess(this.item);

  /// The item added to the repository.
  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when a new item is created in the repository successfully.
class RepoV3ItemCreateSuccess<Entity> extends RepositoryV3State<Entity> {
  /// Creates a new instance of [RepoV3ItemCreateSuccess].
  const RepoV3ItemCreateSuccess(this.item);

  /// The item created in the repository.
  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when an item is deleted from the repository.
class RepoV3ItemDeleteSuccess<Entity> extends RepositoryV3State<Entity> {
  /// Creates a new instance of [RepoV3ItemDeleteSuccess].
  const RepoV3ItemDeleteSuccess(this.item);

  /// The item deleted from the repository.
  final Entity item;

  @override
  List<Object?> get props => [item];

  @override
  String toString() => '$runtimeType { item: $item }';
}

/// State for when an item is updated in the repository.
class RepoV3ItemUpdateSuccess<Output, Entity>
    extends RepositoryV3State<Entity> {
  /// Creates a new instance of [RepoV3ItemUpdateSuccess].
  const RepoV3ItemUpdateSuccess(this.previous, this.updated);

  /// The item before the update.
  final Output previous;

  /// The item after the update.
  final Output updated;

  @override
  List<Object?> get props => [previous, updated];

  @override
  String toString() =>
      '$runtimeType { previous: $previous, updated: $updated }';
}
