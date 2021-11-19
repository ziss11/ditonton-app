import 'package:core/data/models/tv_series/tv_series_model.dart';
import 'package:core/data/models/tv_series/tv_series_table.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    type: 'Tv',
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    id: 1,
    ids: const [1, 2, 3],
    title: 'title',
    originCountry: const ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 0,
    posterPath: 'posterPath',
    voteAverage: 0.0,
    voteCount: 0,
  );

  final tTvSeries = TvSeries(
    type: 'Tv',
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    id: 1,
    ids: const [1, 2, 3],
    title: 'title',
    originCountry: const ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 0,
    posterPath: 'posterPath',
    voteAverage: 0.0,
    voteCount: 0,
  );

  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    title: 'title',
    overview: 'overview',
    posterPath: 'posterPath',
    type: 'Tv',
  );

  test('should be a subclass of Tv Series entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });

  test('should return a TvSeriesTable JSON map containing proper data',
      () async {
    // act
    final result = tTvSeriesTable.toJson();
    // assert
    final expectedJsonMap = {
      'id': 1,
      'title': 'title',
      'poster_path': 'posterPath',
      'overview': 'overview',
      'type': 'Tv',
    };
    expect(result, expectedJsonMap);
  });
}
