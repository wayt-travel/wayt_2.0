part of 'user_repository.dart';

/// Base class for the user repository state.
typedef UserRepositoryState = RepositoryState<UserEntity>;

/// The state of the user repository when the user is fetched.
typedef UserRepositoryUserFetched = RepositoryItemFetched<UserEntity>;

/// The state of the user repository when the user is updated in the repository.
typedef UserRepositoryUserUpdated = RepositoryItemUpdated<UserEntity>;
