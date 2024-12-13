import 'package:dio/dio.dart';
import '../models/game_response.dart';
import '../../core/secrets.dart';

class RAWGApiService {
  final Dio _dio;

  RAWGApiService(this._dio) {
    _dio.options.baseUrl = "https://api.rawg.io/api/";
    _dio.options.headers = {
      "Accept": "application/json",
    };
  }

  Future<List<GameResponse>> searchGames(String query, int pageSize) async {
    final response = await _dio.get(
      "games",
      queryParameters: {
        "key": Secrets.apiKey,
        "search": query,
        "page_size": pageSize,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['results'];
      return data.map((json) => GameResponse.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar jogos: ${response.statusCode}");
    }
  }

  Future<GameResponse> getGameDetails(int gameId) async {
    final response = await _dio.get(
      "games/$gameId",
      queryParameters: {
        "key": Secrets.apiKey,
      },
    );

    if (response.statusCode == 200) {
      return GameResponse.fromJson(response.data);
    } else {
      throw Exception("Erro ao buscar detalhes do jogo: ${response.statusCode}");
    }
  }
}
