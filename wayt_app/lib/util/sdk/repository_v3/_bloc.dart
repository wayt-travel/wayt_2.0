part of 'repository_v3.dart';

/// Callback function for repository events.
typedef RepositoryV3EventCallback<Err, Value> = void Function(
  Either<Err, Value> result,
);

/// Task function for repository events.
typedef RepositoryV3EventTask<Err, Value, State> = TaskEither<Err, Value>
    Function(
  Emitter<State?> emit,
);

sealed class _BlocEvent<Err, Value, State> {
  final RepositoryV3EventTask<Err, Value, State> f;
  final RepositoryV3EventCallback<Err, Value>? callback;

  _BlocEvent(
    this.f, {
    this.callback,
  });
}

final class _SequentialBlocEvent<Err, Value, State>
    extends _BlocEvent<Err, Value, State> {
  _SequentialBlocEvent(super.f, {super.callback});
}

final class _ConcurrentBlocEvent<Err, Value, State>
    extends _BlocEvent<Err, Value, State> {
  _ConcurrentBlocEvent(
    super.f, {
    super.callback,
  });
}

final class _RepoBloc<Err, Value, State>
    extends Bloc<_BlocEvent<Err, Value, State>, State?> {
  _RepoBloc() : super(null);
}
