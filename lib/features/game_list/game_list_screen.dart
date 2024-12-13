import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/game.dart';

class GameListScreen extends StatelessWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Beaten"),
        actions: [
          // Botão de alternar tema
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategorySection(
            "Estou Jogando",
            gameProvider.games.where((g) => g.status == "Estou Jogando").toList(),
          ),
          _buildCategorySection(
            "Quero Jogar",
            gameProvider.games.where((g) => g.status == "Quero Jogar").toList(),
          ),
          _buildCategorySection(
            "Já Joguei",
            gameProvider.games.where((g) => g.status == "Já Joguei").toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-game');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Game> games) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: games.isEmpty
                ? const Center(child: Text("Nenhum jogo nesta categoria."))
                : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return ListTile(
                  leading: Image.network(
                    game.avatar,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(game.name),
                  onTap: () async {
                    final updated = await Navigator.pushNamed(
                      context,
                      '/game-details',
                      arguments: game,
                    );
                    if (updated == true) {
                      context.read<GameProvider>().loadGames();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
