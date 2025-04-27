import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/error/error.dart';
import 'package:wayt_app/util/sdk/repository_v3/repository_v3.dart';

class _Item {
  const _Item(this.id, this.value);

  final String id;
  final int value;

  _Item copyWith({String? id, int? value}) {
    return _Item(id ?? this.id, value ?? this.value);
  }
}

Future<void> _wait([int ms = 2000]) =>
    Future.delayed(Duration(milliseconds: ms));

Map<String, _Item> _generate([int count = 100]) => Map.fromEntries(
      List.generate(count, (_) => const Uuid().v4()).map(
        (id) => MapEntry(
          id,
          _Item(id, 0),
        ),
      ),
    );

class _Repo extends Repository<String, _Item, RepositoryState<_Item>> {
  _Repo() : super();

  Future<Map<String, _Item>> fetch() async {
    cache
      ..clear()
      ..saveAll(_generate());
    emit(RepositoryCollectionFetched(cache.values.toList()));
    return cache.items;
  }

  Future<_Item> update(String id, int value) async {
    await _wait();
    final item = cache.getOrThrow(id);
    final updatedItem = item.copyWith(value: value);
    cache.save(id, updatedItem);
    emit(RepositoryItemUpdated(item, updatedItem));
    return updatedItem;
  }

  Future<void> delete(String id) async {
    final item = cache.getOrThrow(id);
    cache.delete(id);
    emit(RepositoryItemDeleted(item));
  }
}

class _RepoV3
    extends RepositoryV3<String, _Item, RepositoryState<_Item>, WError> {
  _RepoV3();

  WTaskEither<List<_Item>> fetch() {
    return queueSequential<List<_Item>>(
      (emit) => TaskEither(() async {
        cache
          ..clear()
          ..addAll(_generate());
        emit(RepositoryCollectionFetched(cache.values.toList()));
        return Either.right(cache.values.toList());
      }),
    );
  }

  WTaskEither<_Item> update(String id, int value) {
    return queueSequential(
      (emit) => TaskEither.tryCatch(
        () async {
          await _wait();
          final item = getOrThrow(id);
          final updatedItem = item.copyWith(value: value);
          cache[id] = updatedItem;
          emit(RepositoryItemUpdated(item, updatedItem));
          return updatedItem;
        },
        (_, __) => $errors.core.generic,
      ),
    );
  }

  WTaskEither<_Item> delete(String id) {
    return queueSequential(
      (emit) => TaskEither.tryCatch(
        () async {
          final item = getOrThrow(id);
          cache.remove(id);
          emit(RepositoryItemDeleted(item));
          return item;
        },
        (_, __) => $errors.core.generic,
      ),
    );
  }
}

class _BlocObserver extends BlocObserver {
  const _BlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    // ignore: avoid_print
    print('${bloc.runtimeType} ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_print
    print('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // ignore: avoid_print
    print('${bloc.runtimeType} $error\n$stackTrace');
  }
}

void main() {
  late _Repo repo;
  late _RepoV3 repoV3;

  setUp(() {
    Bloc.observer = const _BlocObserver();
    repo = _Repo();
    repoV3 = _RepoV3();
  });

  tearDown(() {
    // ignore: invalid_use_of_protected_member
    repo.close();
    repoV3.close();
  });

  group('Repository (old)', () {
    test('Throws on concurrent changes', () async {
      await repo.fetch();
      expect(repo.items.isNotEmpty, true);
      final id = repo.items.first.id;
      await expectLater(
        () => Future.wait([
          repo.update(id, 100),
          repo.delete(id),
        ]),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('RepositoryV3 (new)', () {
    test('Does not throw when executed sequentially', () async {
      await repoV3.fetch().run();
      expect(repoV3.items.isNotEmpty, true);
      final count = repoV3.items.length;
      final id = repoV3.values.first.id;
      await Future.wait([
        repoV3.update(id, 100).run(),
        repoV3.delete(id).run(),
      ]);
      expect(repoV3.get(id), isNull);
      expect(repoV3.items.length, count - 1);
    });
  });
}
