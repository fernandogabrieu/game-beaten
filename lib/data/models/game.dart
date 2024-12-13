import 'package:floor/floor.dart';

@entity
class Game {
  @primaryKey
  final int id; // ID único do jogo

  final String name; // Nome do jogo
  final String avatar; // URL da capa do jogo
  final String status; // "Estou Jogando", "Quero Jogar", "Já Joguei"

  final String? releaseDate; // Ano de lançamento
  final String? genres; // Gêneros do jogo
  final String? developers; // Desenvolvedoras
  final String? publishers; // Distribuidoras

  Game({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    this.releaseDate,
    this.genres,
    this.developers,
    this.publishers,
  });
}
