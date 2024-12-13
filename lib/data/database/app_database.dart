import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:gamebeaten/data/models/game.dart';
import 'package:gamebeaten/data/database/game_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Game])
abstract class AppDatabase extends FloorDatabase {
  GameDao get gameDao;
}
