part of 'travel_document_repository.dart';

/// The state of the [TravelDocumentRepository].
typedef TravelDocumentRepositoryState = RepositoryState<TravelDocumentEntity>;

/// The state of the [TravelDocumentRepository] when a new item is added.
typedef TravelDocumentRepositoryEntityAdded
    = RepositoryItemAdded<TravelDocumentEntity>;

/// The state of the [TravelDocumentRepository] when a collection of items is
/// fetched.
typedef TravelDocumentRepositoryCollectionFetched
    = RepositoryCollectionFetched<TravelDocumentEntity>;

/// The state of the [TravelDocumentRepository] when a single item is fetched.
typedef TravelDocumentRepositoryItemFetched
    = RepositoryItemFetched<TravelDocumentEntity>;

/// The state of the [TravelDocumentRepository] when a single item is updated.
typedef TravelDocumentRepositoryItemUpdated
    = RepositoryItemUpdated<TravelDocumentEntity>;

/// The state of the [TravelDocumentRepository] when a single item is deleted.
typedef TravelDocumentRepositoryItemDeleted
    = RepositoryItemDeleted<TravelDocumentEntity>;
