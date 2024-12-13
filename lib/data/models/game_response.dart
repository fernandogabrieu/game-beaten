import 'package:json_annotation/json_annotation.dart';

part 'game_response.g.dart';

@JsonSerializable()
class GameResponse {
  final int id;
  final String name;
  @JsonKey(name: "background_image")
  final String? cover;
  final String? released;
  final String? description;
  final List<Genre>? genres;
  final List<Company>? developers;
  final List<Company>? publishers;

  GameResponse({
    required this.id,
    required this.name,
    this.cover,
    this.released,
    this.description,
    this.genres,
    this.developers,
    this.publishers,
  });

  factory GameResponse.fromJson(Map<String, dynamic> json) =>
      _$GameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GameResponseToJson(this);
}

@JsonSerializable()
class Genre {
  final String name;

  Genre({required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
class Company {
  final String name;

  Company({required this.name});

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
