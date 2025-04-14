import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

export 'repository_v2_event.dart';
export 'repository_v2_state.dart';

part '_bloc.dart';

/// Event handler function for repository events.
/// It takes an [Event] and an [Emitter] as parameters and returns a
/// [FutureOr] of type [R].
///
/// It is inspired by the [Bloc] event handler function.
typedef RepoV2EventHandler<R, Event, State> = FutureOr<R> Function(
  Event event,
  Emitter<State> emit,
);

/// Event handler that is executed conditionally.
typedef RepoV2ConditionalEventHandler<R, Event, State>
    = RepoV2EventHandler<({bool executed, R? result}), Event, State>;

/// {@template repository_v2}
/// Base class for repositories.
///
/// It provides a way to centralize the logic handling a specific domain entity.
///
/// Entities of type [Entity] are stored in a [cache] and can be accessed by
/// their [Key] using the [get], [keys], [values], [items] and [getOrThrow]
/// methods.
///
/// The repository is event-driven, meaning it accepts events of type [Event]
/// added via [add] (and similar) methods, processes them and responds emitting
/// states of type [State].
///
/// Upon instantiation, you need to register the event handlers using the [on]
/// method, just like you would do with a [Bloc].
///
/// Internally it uses a [Bloc] to handle events and states. The events are
/// processed sequentially or concurrently depending on the method used to add
/// them to the repository. Usually it is recommended to use [addSequential]
/// method to ensure that the events are processed in the order they are added
/// and one at a time, making the repository thread-safe.
///
/// Any actor can subscribe to the repository events using the [listen] method.
/// {@endtemplate}
abstract class RepositoryV2<Key, Entity, Event, State, Err> with LoggerMixin {
  /// Internal cache storing the items of the repository.
  @protected
  Map<Key, Entity> cache = {};

  /// Internal bloc that handles the events and states of the repository.
  final _bloc = _RepoBloc<dynamic, Err, Event, State>();

  /// List of event handlers that are executed when an event is added to the
  /// repository.
  ///
  /// Normally only one handler should run for a specific event.
  final _handlers = <RepoV2ConditionalEventHandler<dynamic, Event, State?>>[];

  /// Function that transforms an Error/Exception into an instance of a
  /// managed [Err].
  ///
  /// If you want to use [Exception] or [Error] as [Err], you can define this
  /// as the identity function.
  final Err Function(Object error) errorTransformer;

  /// {@macro repository_v2}
  RepositoryV2({required this.errorTransformer}) {
    /// Registers the bloc events handlers.
    _bloc

      /// Events that are executed sequentially.
      ..on<_SequentialBlocEvent<dynamic, Err, Event, State>>(
        _handler,
        transformer: sequential(),
      )

      /// Events that can be executed concurrently.
      ..on<_ConcurrentBlocEvent<dynamic, Err, Event, State>>(
        _handler,
        transformer: concurrent(),
      );
  }

  /// Registers the repository event handler for the given event type [E].
  ///
  /// The handler will be executed when an event of type [E] is added to the
  /// repository via [add] method (or similar).
  void on<E extends Event, R>(RepoV2EventHandler<R, E, State?> handler) =>
      _handlers.add((event, emit) async {
        // The handler is executed only if the event is of type E.
        if (event is E) {
          return (
            executed: true,
            result: await handler(event, emit),
          );
        }
        // If the event is not of type E, we return executed=false and
        // result=null.
        return (
          executed: false,
          result: null,
        );
      });

  /// Alias for [addSequential].
  ///
  /// {@macro repository_v2_add_sequential}
  void add<Value>(
    Event event, {
    RepositoryV2EventCallback<Err, Value>? callback,
  }) =>
      addSequential(event, callback: callback);

  /// {@template repository_v2_add_sequential}
  ///
  /// Adds a new [event] to the repository that will be process sequentially
  /// with a FIFO strategy.
  ///
  /// This ensures that all events are processed in the order they are added and
  /// one at a time, making the repository thread-safe.
  ///
  /// [Value] is the expected type of the result of handler of the event.
  /// The [callback] function is executed when the event is processed. If the
  /// event is processed successfully the [Either.right] will contain the
  /// result of the event handler. If the event fails, the [Either.left] will
  /// contain the error.
  /// {@endtemplate}
  void addSequential<Value>(
    Event event, {
    RepositoryV2EventCallback<Err, Value>? callback,
  }) =>
      _bloc.add(
        _SequentialBlocEvent<Value, Err, Event, State>(
          event,
          callback: callback,
        ),
      );

  /// Adds a new [event] to the repository that will be process concurrently.
  ///
  /// **It is generally recommended to use [addSequential] instead of this
  /// method.**
  ///
  /// See [addSequential] for more details.
  void addConcurrent<Value>(
    Event event, {
    RepositoryV2EventCallback<Err, Value>? callback,
  }) =>
      _bloc.add(
        _ConcurrentBlocEvent<Value, Err, Event, State>(
          event,
          callback: callback,
        ),
      );

  /// Adds a new [event] to the repository that will be process sequentially
  /// with a FIFO strategy and waits for the result.
  ///
  /// Similar to [addSequential], but returns a [Future] that completes with the
  /// result of the event handler. This is useful when you want to wait for the
  /// result of the event before continuing.
  ///
  /// See [addSequential] for more details.
  Future<Either<Err, Value>> addSequentialAndWait<Value>(
    Event event,
  ) async {
    final completer = Completer<Either<Err, Value>>();
    addSequential(
      event,
      callback: completer.complete,
    );
    return completer.future;
  }

  /// Adds a new [event] to the repository that will be process concurrently
  /// and waits for the result.
  ///
  /// Similar to [addSequentialAndWait], but allows concurrent execution of
  /// events.
  ///
  /// **It is generally recommended to use [addSequentialAndWait] instead of
  /// this method.**
  Future<Either<Err, Value>> addConcurrentAndWait<Value>(
    Event event,
  ) async {
    final completer = Completer<Either<Err, Value>>();
    addConcurrent(
      event,
      callback: completer.complete,
    );
    return completer.future;
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
  Future<void> _handler<E extends _BlocEvent<dynamic, Err, Event, State>>(
    E event,
    Emitter<State?> emit,
  ) async {
    dynamic result;
    try {
      // Loop over all registered handlers
      for (final handler in _handlers) {
        // Call the handler
        final r = (await handler(event.repoEvent, emit));
        if (r.executed) {
          // If the handler executed, set the result and break
          // the loop as we expect only one handler to execute
          // for each event.
          result = r.result;
          break;
        }
      }
      // Call the onSuccess callback with the result
      event.callback?.call(Either.right(result));
    } catch (e, s) {
      final error = errorTransformer(e);
      logger.e('Unhandled error in repository event handler: $error', e, s);
      event.callback?.call(Either.left(error));
    }
  }
}
