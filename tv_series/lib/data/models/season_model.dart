import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/season.dart';

class SeasonModel extends Equatable {
  const SeasonModel({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  factory SeasonModel.fromJson(Map<String, dynamic> map) => SeasonModel(
        airDate: map['air_date'] ?? '',
        episodeCount: map['episode_count'],
        id: map['id'],
        name: map['name'],
        overview: map['overview'],
        posterPath: map['poster_path'],
        seasonNumber: map['season_number'],
      );

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episode_count': episodeCount,
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'season_number': seasonNumber,
      };

  Season toEntity() => Season(
        airDate: airDate ?? '',
        episodeCount: episodeCount,
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath ?? '',
        seasonNumber: seasonNumber,
      );

  @override
  List<Object?> get props => [
        airDate,
        episodeCount,
        id,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}
