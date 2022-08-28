import 'package:equatable/equatable.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

import 'episode_model.dart';

// ignore: must_be_immutable
class TvSeriesDetailModel extends Equatable {
  TvSeriesDetailModel({
    required this.type,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homePage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.title,
    required this.numberOfEpisode,
    required this.numberOfSeason,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
  });

  String? type;
  final String? backdropPath;
  final List<int>? episodeRunTime;
  final String? firstAirDate;
  final List<GenreModel>? genres;
  final String? homePage;
  final int id;
  final bool? inProduction;
  final List<String>? languages;
  final String? lastAirDate;
  final EpisodeModel? lastEpisodeToAir;
  final String? title;
  final int? numberOfEpisode;
  final int? numberOfSeason;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<SeasonModel>? seasons;
  final String? status;
  final String? tagline;
  final double? voteAverage;
  final int? voteCount;

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> map) =>
      TvSeriesDetailModel(
        type: map['type'] ?? '',
        backdropPath: map['backdrop_path'] ?? '',
        episodeRunTime: List<int>.from(map['episode_run_time'].map((x) => x)),
        firstAirDate: map['first_air_date'],
        genres: List<GenreModel>.from(
            map['genres'].map((x) => GenreModel.fromJson(x)).toList()),
        homePage: map['homepage'],
        id: map['id'],
        inProduction: map['in_production'],
        languages: List<String>.from(map['languages'].map((x) => x)),
        lastAirDate: map['last_air_date'],
        lastEpisodeToAir: EpisodeModel.fromJson(map['last_episode_to_air']),
        title: map['name'],
        numberOfEpisode: map['number_of_episodes'],
        numberOfSeason: map['number_of_seasons'],
        originCountry:
            List<String>.from(map['origin_country'].map((x) => x)).toList(),
        originalLanguage: map['original_language'],
        originalName: map['original_name'],
        overview: map['overview'],
        popularity: map['popularity'].toDouble(),
        posterPath: map['poster_path'],
        seasons: List<SeasonModel>.from(
            map['seasons'].map((x) => SeasonModel.fromJson(x)).toList()),
        status: map['status'],
        tagline: map['tagline'],
        voteAverage: map['vote_average'].toDouble(),
        voteCount: map['vote_count'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'backdrop_path': backdropPath,
        'episode_run_time':
            List<int>.from(episodeRunTime!.map((x) => x)).toList(),
        'first_air_date': firstAirDate,
        'genres': List<dynamic>.from(genres!.map((x) => x.toJson())).toList(),
        'homepage': homePage,
        'id': id,
        'in_production': inProduction,
        'languages': List<String>.from(languages!.map((x) => x)).toList(),
        'last_air_date': lastAirDate,
        'last_episode_to_air': lastEpisodeToAir!.toJson(),
        'title': title,
        'number_of_episodes': numberOfEpisode,
        'number_of_seasons': numberOfSeason,
        'origin_country':
            List<dynamic>.from(originCountry!.map((x) => x)).toList(),
        'original_language': originalLanguage,
        'original_name': originalName,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'seasons': List<dynamic>.from(seasons!.map((x) => x.toJson())).toList(),
        'status': status,
        'tagline': tagline,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  TvSeriesDetail toEntity() => TvSeriesDetail(
        type: type!,
        backdropPath: backdropPath,
        episodeRunTime: episodeRunTime!.map((x) => x).toList(),
        firstAirDate: firstAirDate,
        genres: genres!.map((x) => x.toEntity()).toList(),
        id: id,
        languages: languages!.map((x) => x).toList(),
        lastAirDate: lastAirDate,
        title: title,
        numberOfEpisode: numberOfEpisode,
        numberOfSeason: numberOfSeason,
        originCountry: originCountry!.map((x) => x).toList(),
        originalLanguage: originalLanguage,
        originalName: originalName,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        seasons: seasons!.map((x) => x.toEntity()).toList(),
        status: status,
        tagline: tagline,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

  @override
  List<Object?> get props => [
        type,
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        homePage,
        id,
        inProduction,
        languages,
        lastAirDate,
        lastEpisodeToAir,
        title,
        numberOfEpisode,
        numberOfSeason,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        seasons,
        status,
        tagline,
        voteAverage,
        voteCount,
      ];
}
