import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_model.dart';
import 'package:movie/data/models/movie_table.dart';
import 'package:movie/domain/entities/movie.dart';

void main() {
  final tMovieModel = MovieModel(
    type: 'Movie',
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovie = Movie(
    type: 'Movie',
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieJson = {
    "type": 'Movie',
    'adult': false,
    'backdrop_path': 'backdropPath',
    'genre_ids': [1, 2, 3],
    'id': 1,
    'original_title': 'originalTitle',
    'overview': 'overview',
    'popularity': 1,
    'poster_path': 'posterPath',
    'release_date': 'releaseDate',
    'title': 'title',
    'video': false,
    'vote_average': 1,
    'vote_count': 1,
  };

  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    type: 'type',
  );
  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });

  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap = tMovieJson;
    // act
    final result = MovieModel.fromJson(jsonMap);
    // assert
    expect(result, tMovieModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tMovieModel.toJson();
    // assert
    final expectedJsonMap = tMovieJson;
    expect(result, expectedJsonMap);
  });

  test('should return a MovieTable JSON map containing proper data', () async {
    // act
    final result = tMovieTable.toJson();
    // assert
    final expectedJsonMap = {
      'id': 1,
      'title': 'title',
      'posterPath': 'posterPath',
      'overview': 'overview',
      'type': 'type',
    };
    expect(result, expectedJsonMap);
  });
}
