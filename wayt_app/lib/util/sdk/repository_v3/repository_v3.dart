import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../util.dart';

export 'repository_v3_state.dart';

part '_bloc.dart';

/// {@template repository_v3}
/// Base class for repositories.
///
/// It provides a way to centralize the logic handling a specific domain entity.
///
/// Entities of type [Entity] are stored in a [cache] and can be accessed by
/// their [Key] using the [get], [keys], [values], [items] and [getOrThrow]
/// methods.
///
/// The repository allows to execute tasks that can be either sequential or
/// concurrent. The tasks are executed using the [queueSequential] and
/// [queueConcurrent] methods. With the former, the tasks are executed in the
/// order they are added to the queue and one at a time. With the latter, the
/// tasks are executed concurrently and the order is not guaranteed.
/// The two methods use different queues, meaning that if you add a task
/// using [queueConcurrent] while another task is being processed using
/// [queueSequential], they will be executed in parallel.
///
/// Usually it is recommended to use [queueSequential] method to ensure that
/// the tasks are processed in the order they are added and one at a time,
/// making the repository thread-safe.
///
/// Internally it uses a [Bloc] to handle events and states. The events are
/// processed sequentially or concurrently depending on the method used to add
/// them to the repository.
///
/// Any actor can subscribe to the repository events using the [listen] method.
/// {@endtemplate}
@SdkCandidate()
abstract class RepositoryV3<Key, Entity, State, Err> with LoggerMixin {
  /// Internal cache storing the items of the repository.
  @protected
  Map<Key, Entity> cache = {};

  /// Internal bloc that handles the events and states of the repository.
  final _bloc = _RepoBloc<Err, dynamic, State>();

  /// {@macro repository_v3}
  RepositoryV3() {
    /// Registers the bloc events handlers.
    _bloc

      /// Events that are executed sequentially.
      ..on<_SequentialBlocEvent<Err, dynamic, State>>(
        _handler,
        transformer: sequential(),
      )

      /// Events that can be executed concurrently.
      ..on<_ConcurrentBlocEvent<Err, dynamic, State>>(
        _handler,
        transformer: concurrent(),
      );
  }

  /// Queue a new [task] in the repository that will be process sequentially
  /// with a FIFO strategy and waits for the result.
  @protected
  TaskEither<Err, Value> queueSequential<Value>(
    RepositoryV3EventTask<Err, Value, State> task,
  ) {
    final completer = Completer<Either<Err, Value>>();
    _bloc.add(
      _SequentialBlocEvent<Err, dynamic, State>(
        task,
        callback: (either) {
          // This is a workaround needed because the either that we get from the
          // event execution is of type Either<Err, dynamic> and we need to cast
          // it to Either<Err, Value> to avoid type errors.
          completer.complete(
            either.match(
              Either<Err, Value>.left,
              // ignore: unnecessary_cast
              (value) => Either<Err, Value>.right(value as Value),
            ),
          );
        },
      ),
    );
    return TaskEither(() => completer.future);
  }

  /// Queue a new [task] in the repository that will be process concurrently
  /// with all the other tasks queued with this method.
  ///
  /// **It is generally recommended to use [queueSequential] instead of this
  /// method.**
  @protected
  TaskEither<Err, Value> queueConcurrent<Value>(
    RepositoryV3EventTask<Err, Value, State> task,
  ) {
    final completer = Completer<Either<Err, Value>>();
    _bloc.add(
      _ConcurrentBlocEvent<Err, dynamic, State>(
        task,
        callback: (either) {
          // This is a workaround needed because the either that we get from the
          // event execution is of type Either<Err, dynamic> and we need to cast
          // it to Either<Err, Value> to avoid type errors.
          completer.complete(
            either.match(
              Either<Err, Value>.left,
              // ignore: unnecessary_cast
              (value) => Either<Err, Value>.right(value as Value),
            ),
          );
        },
      ),
    );
    return TaskEither(() => completer.future);
  }

  /// Closes the repository and releases all resources, i.e., the bloc.
  void close() => _bloc.close();

  /// Returns the items in the repository as an immutable list.
  List<Entity> get values => List.unmodifiable(cache.values);

  /// Returns the keys of the items in the repository as an immutable list.
  List<Key> get keys => List.unmodifiable(cache.keys);

  /// Returns the repository items as an immutable map.
  Map<Key, Entity> get items => Map.unmodifiable(cache);

  /// Gets the item by [key] if exists, otherwise returns null.
  ///
  /// If [orElse] is provided, it will be called and its result will be returned
  /// if the item does not exist.
  Entity? get(Key key, {Entity Function()? orElse}) {
    final item = cache[key];
    if (item != null) return item;
    if (orElse != null) return orElse();
    return null;
  }

  /// Returns the item by [key]. If it does not exist it throws a
  /// [ArgumentError].
  Entity getOrThrow(Key key) => get(
        key,
        orElse: () => throw ArgumentError.value(
          key,
          'key',
          'Item with key $key not found.',
        ),
      )!;

  /// Listens the stream of states.
  ///
  /// Make sure to call [close] when you are done with the stream to avoid
  /// memory leaks.
  ///
  /// [onError], [onDone] and [cancelOnError] are optional parameters that are
  /// passed to the stream subscription.
  @nonVirtual
  StreamSubscription<State> listen(
    void Function(State state) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _bloc.stream.where((state) => state != null).cast<State>().listen(
            (value) => onData(value),
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );

  /// Handler for bloc events (used in [Bloc.on]).
  Future<void> _handler<E extends _BlocEvent<Err, dynamic, State>>(
    E event,
    Emitter<State?> emit,
  ) async {
    try {
      final result = await event.f(emit).run();
      event.callback?.call(result);
    } catch (e) {
      throw StateError('Unexpected error thrown by TaskEither execution $e');
    }
  }
}
