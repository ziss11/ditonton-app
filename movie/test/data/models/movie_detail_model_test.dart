import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie_detail.dart';

import '../../json_reader.dart';

void main() {
  final tMovieDetailModel = MovieDetailResponse(
    type: 'Movie',
    adult: false,
    backdropPath: '/path.jpg',
    budget: 100,
    genres: const [
      GenreModel(
        id: 1,
        name: 'Action',
      ),
    ],
    homepage: 'https://google.com',
    id: 1,
    imdbId: 'imdb1',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    revenue: 12000,
    runtime: 120,
    status: 'Status',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  const tMovieDetail = MovieDetail(
    type: 'Movie',
    adult: false,
    backdropPath: '/path.jpg',
    genres: [
      Genre(
        id: 1,
        name: 'Action',
      ),
    ],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    runtime: 120,
    title: 'Title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of Movie Detail entity', () async {
    final result = tMovieDetailModel.toEntity();
    expect(result, tMovieDetail);
  });

  test('should return a valid model from JSON', () {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/movie_detail.json'));
    // act
    final result = MovieDetailResponse.fromJson(jsonMap);
    // assert
    expect(result, tMovieDetailModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tMovieDetailModel.toJson();
    // assert
    final expectedJsonMap = {
      "type": 'Movie',
      "adult": false,
      "backdrop_path": "/path.jpg",
      "budget": 100,
      "genres": [
        {"id": 1, "name": "Action"}
      ],
      "homepage": "https://google.com",
      "id": 1,
      "imdb_id": "imdb1",
      "original_language": "en",
      "original_title": "Original Title",
      "overview": "Overview",
      "popularity": 1.0,
      "poster_path": "/path.jpg",
      "release_date": "2020-05-05",
      "revenue": 12000,
      "runtime": 120,
      "status": "Status",
      "tagline": "Tagline",
      "title": "Title",
      "video": false,
      "vote_average": 1.0,
      "vote_count": 1
    };
    expect(result, expectedJsonMap);
  });
}
