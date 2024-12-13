import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';
import '../../data/models/game.dart';

class GameDetailsScreen extends StatefulWidget {
  final Game game;

  const GameDetailsScreen({super.key, required this.game});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  late String _status;
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    _status = widget.game.status;
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  // Formatar Data
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "Desconhecido";
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    } catch (_) {
      return "Desconhecido";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await _showDeleteConfirmationDialog();
              if (confirmed) {
                await database.gameDao.deleteGame(widget.game);
                Navigator.pop(context, true); // Retorna à lista e atualiza
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card com detalhes do jogo
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        widget.game.avatar,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Título: ${widget.game.name}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Ano de Lançamento: ${_formatDate(widget.game.releaseDate)}"),
                    const SizedBox(height: 8),
                    Text("Gêneros: ${widget.game.genres ?? 'Desconhecido'}"),
                    const SizedBox(height: 8),
                    if (widget.game.developers != null && widget.game.developers!.isNotEmpty)
                      Text("Desenvolvedoras: ${widget.game.developers}"),
                    if (widget.game.publishers != null && widget.game.publishers!.isNotEmpty)
                      Text("Distribuidoras: ${widget.game.publishers}"),
                  ],
                ),
              ),
            ),
            // Campo de Status
            const Text(
              "Status:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _status,
              items: ["Quero Jogar", "Estou Jogando", "Já Joguei"]
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const Spacer(),
            // Botão de salvar alterações
            Center(
              child: ElevatedButton(
                onPressed: _status != widget.game.status
                    ? () async {
                  final updatedGame = Game(
                    id: widget.game.id,
                    name: widget.game.name,
                    avatar: widget.game.avatar,
                    status: _status,
                    releaseDate: widget.game.releaseDate,
                    genres: widget.game.genres,
                    developers: widget.game.developers,
                    publishers: widget.game.publishers,
                  );
                  await database.gameDao.updateGame(updatedGame);
                  Navigator.pop(context, true); // Retorna à lista e atualiza
                }
                    : null, // Desabilitado se não houver alterações
                child: const Text("Salvar Alterações"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Jogo"),
        content: const Text("Tem certeza de que deseja excluir este jogo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    ) ??
        false;
  }
}
