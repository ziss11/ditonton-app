import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

// ignore: must_be_immutable
class TvSeriesModel extends Equatable {
  TvSeriesModel({
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

  String? type;
  final String? firstAirDate;
  final String? backdropPath;
  final List<int>? ids;
  final int? id;
  final String? title;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final double? voteAverage;
  final int? voteCount;

  factory TvSeriesModel.fromJson(Map<String, dynamic> map) => TvSeriesModel(
        type: map['type'] ?? '',
        backdropPath: map['backdrop_path'],
        firstAirDate: map['first_air_date'],
        id: map['id'],
        ids: List<int>.from(map['genre_ids'].map((x) => x)).toList(),
        title: map['name'],
        originCountry:
            List<String>.from(map['origin_country'].map((x) => x)).toList(),
        originalLanguage: map['original_language'],
        originalName: map['original_name'],
        overview: map['overview'],
        popularity: map['popularity'].toDouble(),
        posterPath: map['poster_path'],
        voteAverage: map['vote_average'].toDouble(),
        voteCount: map['vote_count'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'backdrop_path': backdropPath,
        'first_air_date': firstAirDate,
        'id': id,
        'genre_ids': List<int>.from(ids!.map((x) => x)).toList(),
        'title': title,
        'origin_country':
            List<String>.from(originCountry!.map((x) => x)).toList(),
        'original_language': originalLanguage,
        'original_name': originalName,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  TvSeries toEntity() => TvSeries(
        type: type!,
        backdropPath: backdropPath,
        firstAirDate: firstAirDate,
        id: id!,
        ids: ids,
        title: title!,
        originCountry: originCountry!.map((x) => x).toList(),
        originalLanguage: originalLanguage,
        originalName: originalName,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

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
