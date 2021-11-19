import 'package:core/domain/entities/movie/genre.dart';
import 'package:core/domain/entities/tv_series/season.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetail extends Equatable {
  const TvSeriesDetail({
    required this.type,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.languages,
    required this.lastAirDate,
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

  final String type;
  final String? backdropPath;
  final List<int> episodeRunTime;
  final String? firstAirDate;
  final List<Genre>? genres;
  final int id;
  final List<String>? languages;
  final String? lastAirDate;
  final String? title;
  final int? numberOfEpisode;
  final int? numberOfSeason;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<Season>? seasons;
  final String? status;
  final String? tagline;
  final double? voteAverage;
  final int? voteCount;

  @override
  List<Object?> get props => [
        type,
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        id,
        languages,
        lastAirDate,
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
