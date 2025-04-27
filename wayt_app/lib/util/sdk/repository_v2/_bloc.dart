part of 'repository_v2.dart';

/// Callback function for repository events.
typedef RepositoryV2EventCallback<Err, Value> = void Function(
  Either<Err, Value> result,
);

sealed class _BlocEvent<Value, Err, Event, State> {
  final Event repoEvent;
  final RepositoryV2EventCallback<Err, Value>? callback;

  _BlocEvent(
    this.repoEvent, {
    this.callback,
  });

  @override
  String toString() => '$repoEvent';
}

final class _SequentialBlocEvent<Value, Err, Event, State>
    extends _BlocEvent<Value, Err, Event, State> {
  _SequentialBlocEvent(super.repoEvent, {super.callback});
}

final class _ConcurrentBlocEvent<Value, Err, Event, State>
    extends _BlocEvent<Value, Err, Event, State> {
  _ConcurrentBlocEvent(
    super.repoEvent, {
    super.callback,
  });
}

final class _RepoBloc<Value, Err, Event, State>
    extends Bloc<_BlocEvent<Value, Err, Event, State>, State?> {
  _RepoBloc() : super(null);
}
