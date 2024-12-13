import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/api/rawg_api_service.dart';
import '../../data/models/game_response.dart';
import '../../data/models/game.dart';
import 'package:intl/intl.dart';

import '../../providers/game_provider.dart';

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  static const platform = MethodChannel('com.example.gamebeaten/connectivity');
  bool _isConnected = true;

  // Método para verificar a conectividade com a internet
  Future<void> _checkConnectivity() async {
    try {
      final bool result = await platform.invokeMethod('checkConnectivity');
      setState(() {
        _isConnected = result;
      });
    } on PlatformException catch (e) {
      debugPrint("Erro ao verificar conectividade: ${e.message}");
      setState(() {
        _isConnected = false;
      });
    }
  }


  final TextEditingController _searchController = TextEditingController();
  final Dio _dio = Dio();
  late RAWGApiService _apiService;

  List<GameResponse> _searchResults = [];
  GameResponse? _selectedGame;
  bool _isLoadingDetails = false;
  bool _isLoadingSearch = false;

  String _status = "Quero Jogar";

  @override
  void initState() {
    super.initState();
    _apiService = RAWGApiService(_dio);
  }

  // Função para buscar jogos
  void _searchGames() async {
    await _checkConnectivity(); // Verifica a conectividade antes
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sem conexão com a internet.")),
      );
      return;
    }

    if (_searchController.text.isEmpty) return;

    setState(() {
      _searchResults = [];
      _selectedGame = null;
      _isLoadingSearch = true;
    });

    try {
      final results = await _apiService.searchGames(_searchController.text, 10);
      setState(() {
        _searchResults = results;
        _isLoadingSearch = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar jogos: $e")),
      );
      setState(() {
        _isLoadingSearch = false;
      });
    }
  }

  // Função para buscar detalhes do jogo
  void _getGameDetails(GameResponse game) async {
    setState(() {
      _isLoadingDetails = true;
      _selectedGame = null;
      _searchResults = []; // Limpa a lista de resultados ao selecionar um jogo
      _searchController.clear(); // Limpa o campo de pesquisa
    });

    try {
      final details = await _apiService.getGameDetails(game.id);
      setState(() {
        _selectedGame = details;
        _isLoadingDetails = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar detalhes do jogo: $e")),
      );
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  // Função para salvar o jogo
  void _saveGame() async {
    if (_selectedGame == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecione um jogo.")),
      );
      return;
    }

    final newGame = Game(
      id: _selectedGame!.id,
      name: _selectedGame!.name,
      avatar: _selectedGame!.cover ?? '',
      status: _status,
      releaseDate: _selectedGame!.released,
      genres: _selectedGame!.genres?.map((g) => g.name).join(', '),
      developers: _selectedGame!.developers?.map((d) => d.name).join(', '),
      publishers: _selectedGame!.publishers?.map((p) => p.name).join(', '),
    );

    context.read<GameProvider>().addGame(newGame);
    Navigator.pop(context);
  }

  // Função para formatar data
  String _formatDate(String? date) {
    if (date == null) return "Desconhecido";
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return "Desconhecido";
    return DateFormat("dd/MM/yyyy").format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Jogo")),
      resizeToAvoidBottomInset: true, // Ajusta o layout ao teclado
      body: SingleChildScrollView( // Permite rolagem quando necessário
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de busca com botão
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Pesquisar Jogo",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchGames,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Lista de resultados da busca ou indicador de carregamento
            if (_isLoadingSearch)
              const Center(child: CircularProgressIndicator())
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final game = _searchResults[index];
                  return ListTile(
                    leading: game.cover != null
                        ? Image.network(game.cover!, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported),
                    title: Text(game.name),
                    onTap: () => _getGameDetails(game),
                  );
                },
              ),
            const SizedBox(height: 16),
            // Indicador de carregamento ou detalhes do jogo selecionado
            if (_isLoadingDetails)
              const Center(child: CircularProgressIndicator())
            else if (_selectedGame != null) ...[
              // Exibir detalhes do jogo selecionado
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedGame!.cover != null)
                        Image.network(_selectedGame!.cover!, height: 150, fit: BoxFit.cover),
                      const SizedBox(height: 8),
                      Text("Título: ${_selectedGame!.name}", style: const TextStyle(fontSize: 16)),
                      Text("Data de Lançamento: ${_formatDate(_selectedGame!.released)}"),
                      Text(
                        "Gêneros: ${_selectedGame!.genres?.map((g) => g.name).join(', ') ?? 'Desconhecido'}",
                      ),
                      if (_selectedGame!.developers != null &&
                          _selectedGame!.developers!.isNotEmpty)
                        Text(
                          "Desenvolvedor: ${_selectedGame!.developers?.map((d) => d.name).join(', ')}",
                        ),
                      if (_selectedGame!.publishers != null &&
                          _selectedGame!.publishers!.isNotEmpty)
                        Text(
                          "Distribuidora: ${_selectedGame!.publishers?.map((p) => p.name).join(', ')}",
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Seleção de status
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
              const SizedBox(height: 16),
              // Botão para salvar
              ElevatedButton(
                onPressed: _saveGame,
                child: const Text("Salvar Jogo"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
