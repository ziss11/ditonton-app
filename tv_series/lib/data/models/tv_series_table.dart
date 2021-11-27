import 'package:equatable/equatable.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

// ignore: must_be_immutable
class TvSeriesTable extends Equatable {
  final int? id;
  final String? title;
  final String? overview;
  final String? posterPath;
  String type;

  TvSeriesTable({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.type,
  });

  factory TvSeriesTable.fromJson(Map<String, dynamic> map) => TvSeriesTable(
        id: map['id'],
        title: map['name'],
        overview: map['overview'],
        posterPath: map['poster_path'],
        type: map['type'] ?? '',
      );

  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) => TvSeriesTable(
        id: tvSeries.id,
        title: tvSeries.title,
        posterPath: tvSeries.posterPath,
        overview: tvSeries.overview,
        type: tvSeries.type,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'type': type,
      };

  TvSeries toEntity() => TvSeries.watchlist(
        id: id!,
        overview: overview,
        posterPath: posterPath,
        title: title!,
        type: type,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        type,
      ];
}
