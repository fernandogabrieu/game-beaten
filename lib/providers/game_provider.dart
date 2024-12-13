import 'package:flutter/material.dart';
import '../data/database/app_database.dart';
import '../data/models/game.dart';

class GameProvider with ChangeNotifier {
  late AppDatabase _database;
  List<Game> _games = [];

  List<Game> get games => _games;

  Future<void> initializeDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await loadGames();
  }

  Future<void> loadGames() async {
    _games = await _database.gameDao.findAllGames();
    notifyListeners();
  }

  Future<void> addGame(Game game) async {
    await _database.gameDao.insertGame(game);
    await loadGames();
  }

  Future<void> updateGame(Game game) async {
    await _database.gameDao.updateGame(game);
    await loadGames();
  }

  Future<void> deleteGame(Game game) async {
    await _database.gameDao.deleteGame(game);
    await loadGames();
  }
}
