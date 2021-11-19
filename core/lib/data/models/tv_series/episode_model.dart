import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:equatable/equatable.dart';

class EpisodeModel extends Equatable {
  const EpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? airDate;
  final int? episodeNumber;
  final int? id;
  final String? name;
  final String? overview;
  final int? seasonNumber;
  final String? stillPath;
  final double? voteAverage;
  final int? voteCount;

  factory EpisodeModel.fromJson(Map<String, dynamic> map) => EpisodeModel(
      airDate: map['air_date'] ?? '',
      episodeNumber: map['episode_number'] ?? 0,
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      overview: map['overview'] ?? '',
      seasonNumber: map['season_number'] ?? 0,
      stillPath: map['still_path'] ?? '',
      voteAverage: map['vote_average'] ?? 0.0,
      voteCount: map['vote_count'] ?? 0);

  Map<String, dynamic> toJson() => {
        'air_date': airDate,
        'episode_number': episodeNumber,
        'id': id,
        'name': name,
        'overview': overview,
        'season_number': seasonNumber,
        'still_path': stillPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  Episode toEntity() => Episode(
        airDate: airDate!,
        episodeNumber: episodeNumber!,
        id: id!,
        name: name!,
        overview: overview!,
        seasonNumber: seasonNumber!,
        stillPath: stillPath!,
        voteAverage: voteAverage!,
        voteCount: voteCount!,
      );

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        seasonNumber,
        stillPath,
        voteAverage,
        voteCount,
      ];
}
