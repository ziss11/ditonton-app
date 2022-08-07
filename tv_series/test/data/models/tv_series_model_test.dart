import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

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

  final tTvSeriesJson = {
    'type': 'Tv',
    'backdrop_path': 'backdropPath',
    'first_air_date': 'firstAirDate',
    'id': 1,
    'genre_ids': const [1, 2, 3],
    'title': 'title',
    'origin_country': const ['originCountry'],
    'original_language': 'originalLanguage',
    'original_name': 'originalName',
    'overview': 'overview',
    'popularity': 0,
    'poster_path': 'posterPath',
    'vote_average': 0.0,
    'vote_count': 0,
  };

  final tTvSeriesMap = {
    'type': 'Tv',
    'backdrop_path': 'backdropPath',
    'first_air_date': 'firstAirDate',
    'id': 1,
    'genre_ids': const [1, 2, 3],
    'name': 'title',
    'origin_country': const ['originCountry'],
    'original_language': 'originalLanguage',
    'original_name': 'originalName',
    'overview': 'overview',
    'popularity': 0,
    'poster_path': 'posterPath',
    'vote_average': 0.0,
    'vote_count': 0,
  };

  test('should be a subclass of Tv Series entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });

  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap = tTvSeriesMap;
    // act
    final result = TvSeriesModel.fromJson(jsonMap);
    // assert
    expect(result, tTvSeriesModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTvSeriesModel.toJson();
    // assert
    final expectedJsonMap = tTvSeriesJson;
    expect(result, expectedJsonMap);
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
