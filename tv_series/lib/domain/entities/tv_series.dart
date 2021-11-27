import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TvSeries extends Equatable {
  TvSeries({
    required this.type,
    required this.backdropPath,
    required this.firstAirDate,
    required this.id,
    required this.ids,
    required this.title,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  TvSeries.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
    required this.type,
  });

  String type;
  String? backdropPath;
  String? firstAirDate;
  List<int>? ids;
  int? id;
  String? title;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        type,
        backdropPath,
        firstAirDate,
        ids,
        id,
        title,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
