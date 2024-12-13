import 'package:floor/floor.dart';
import 'package:gamebeaten/data/models/game.dart';

@dao
abstract class GameDao {
  // Buscar jogos por status
  @Query('SELECT * FROM Game WHERE status = :status')
  Future<List<Game>> findGamesByStatus(String status);

  // Buscar todos os jogos
  @Query('SELECT * FROM Game')
  Future<List<Game>> findAllGames();

  // Inserir
  @insert
  Future<void> insertGame(Game game);

  // Atualizar
  @update
  Future<void> updateGame(Game game);

  // Excluir
  @delete
  Future<void> deleteGame(Game game);
}
