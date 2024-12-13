// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GameDao? _gameDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Game` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `avatar` TEXT NOT NULL, `status` TEXT NOT NULL, `releaseDate` TEXT, `genres` TEXT, `developers` TEXT, `publishers` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GameDao get gameDao {
    return _gameDaoInstance ??= _$GameDao(database, changeListener);
  }
}

class _$GameDao extends GameDao {
  _$GameDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _gameInsertionAdapter = InsertionAdapter(
            database,
            'Game',
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'avatar': item.avatar,
                  'status': item.status,
                  'releaseDate': item.releaseDate,
                  'genres': item.genres,
                  'developers': item.developers,
                  'publishers': item.publishers
                }),
        _gameUpdateAdapter = UpdateAdapter(
            database,
            'Game',
            ['id'],
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'avatar': item.avatar,
                  'status': item.status,
                  'releaseDate': item.releaseDate,
                  'genres': item.genres,
                  'developers': item.developers,
                  'publishers': item.publishers
                }),
        _gameDeletionAdapter = DeletionAdapter(
            database,
            'Game',
            ['id'],
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'avatar': item.avatar,
                  'status': item.status,
                  'releaseDate': item.releaseDate,
                  'genres': item.genres,
                  'developers': item.developers,
                  'publishers': item.publishers
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Game> _gameInsertionAdapter;

  final UpdateAdapter<Game> _gameUpdateAdapter;

  final DeletionAdapter<Game> _gameDeletionAdapter;

  @override
  Future<List<Game>> findGamesByStatus(String status) async {
    return _queryAdapter.queryList('SELECT * FROM Game WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int,
            name: row['name'] as String,
            avatar: row['avatar'] as String,
            status: row['status'] as String,
            releaseDate: row['releaseDate'] as String?,
            genres: row['genres'] as String?,
            developers: row['developers'] as String?,
            publishers: row['publishers'] as String?),
        arguments: [status]);
  }

  @override
  Future<List<Game>> findAllGames() async {
    return _queryAdapter.queryList('SELECT * FROM Game',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int,
            name: row['name'] as String,
            avatar: row['avatar'] as String,
            status: row['status'] as String,
            releaseDate: row['releaseDate'] as String?,
            genres: row['genres'] as String?,
            developers: row['developers'] as String?,
            publishers: row['publishers'] as String?));
  }

  @override
  Future<void> insertGame(Game game) async {
    await _gameInsertionAdapter.insert(game, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateGame(Game game) async {
    await _gameUpdateAdapter.update(game, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGame(Game game) async {
    await _gameDeletionAdapter.delete(game);
  }
}
