// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameResponse _$GameResponseFromJson(Map<String, dynamic> json) => GameResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      cover: json['background_image'] as String?,
      released: json['released'] as String?,
      description: json['description'] as String?,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      developers: (json['developers'] as List<dynamic>?)
          ?.map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList(),
      publishers: (json['publishers'] as List<dynamic>?)
          ?.map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameResponseToJson(GameResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'background_image': instance.cover,
      'released': instance.released,
      'description': instance.description,
      'genres': instance.genres,
      'developers': instance.developers,
      'publishers': instance.publishers,
    };

Genre _$GenreFromJson(Map<String, dynamic> json) => Genre(
      name: json['name'] as String,
    );

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
      'name': instance.name,
    };

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      name: json['name'] as String,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'name': instance.name,
    };
