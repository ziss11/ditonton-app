import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:tv_series/data/models/episode_model.dart';
import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesDetailModel = TvSeriesDetailModel(
    type: 'Tv',
    backdropPath: 'backdropPath',
    episodeRunTime: const [54],
    firstAirDate: 'firstAirDate',
    genres: const [
      GenreModel(
        id: 10759,
        name: 'name',
      ),
    ],
    homePage: 'homePage',
    id: 93405,
    inProduction: false,
    languages: const ["en", "el"],
    lastAirDate: 'lastAirDate',
    lastEpisodeToAir: const EpisodeModel(
      airDate: 'airDate',
      episodeNumber: 9,
      id: 3222798,
      name: 'name',
      overview: 'overview',
      seasonNumber: 1,
      stillPath: 'stillPath',
      voteAverage: 7.3,
      voteCount: 12,
    ),
    title: 'name',
    numberOfEpisode: 9,
    numberOfSeason: 1,
    originCountry: const ["KR"],
    originalLanguage: 'ko',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 6379.492,
    posterPath: 'posterPath',
    seasons: const [
      SeasonModel(
        airDate: '2021-09-17',
        episodeCount: 9,
        id: 131977,
        name: 'Season 1',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
      ),
    ],
    status: 'Ended',
    tagline: 'tagline',
    voteAverage: 7.9,
    voteCount: 7705,
  );

  const tTvSeriesDetail = TvSeriesDetail(
    type: 'Tv',
    backdropPath: 'backdropPath',
    episodeRunTime: [54],
    firstAirDate: 'firstAirDate',
    genres: [
      Genre(id: 10759, name: "name"),
    ],
    id: 93405,
    languages: ["en", "el"],
    lastAirDate: 'lastAirDate',
    title: 'name',
    numberOfEpisode: 9,
    numberOfSeason: 1,
    originCountry: ["KR"],
    originalLanguage: 'ko',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 6379.492,
    posterPath: 'posterPath',
    seasons: [
      Season(
        airDate: '2021-09-17',
        episodeCount: 9,
        id: 131977,
        name: 'Season 1',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
      ),
    ],
    status: 'Ended',
    tagline: 'tagline',
    voteAverage: 7.9,
    voteCount: 7705,
  );

  test('should be a subclass of Tv Series Detail entity', () async {
    final result = tTvSeriesDetailModel.toEntity();
    expect(result, tTvSeriesDetail);
  });

  test('should return a valid model from JSON', () {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/tv_series_detail.json'));
    // act
    final result = TvSeriesDetailModel.fromJson(jsonMap);
    // assert
    expect(result, tTvSeriesDetailModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTvSeriesDetailModel.toJson();
    // assert
    final expectedJsonMap = {
      "type": 'Tv',
      "backdrop_path": "backdropPath",
      "episode_run_time": [54],
      "first_air_date": "firstAirDate",
      "genres": [
        {"id": 10759, "name": "name"}
      ],
      "homepage": "homePage",
      "id": 93405,
      "in_production": false,
      "languages": ["en", "el"],
      "last_air_date": "lastAirDate",
      "last_episode_to_air": {
        "air_date": "airDate",
        "episode_number": 9,
        "id": 3222798,
        "name": "name",
        "overview": "overview",
        "season_number": 1,
        "still_path": "stillPath",
        "vote_average": 7.3,
        "vote_count": 12
      },
      "title": "name",
      "number_of_episodes": 9,
      "number_of_seasons": 1,
      "origin_country": ["KR"],
      "original_language": "ko",
      "original_name": "originalName",
      "overview": "overview",
      "popularity": 6379.492,
      "poster_path": "posterPath",
      "seasons": [
        {
          "air_date": "2021-09-17",
          "episode_count": 9,
          "id": 131977,
          "name": "Season 1",
          "overview": "overview",
          "poster_path": "posterPath",
          "season_number": 1
        }
      ],
      "status": "Ended",
      "tagline": "tagline",
      "vote_average": 7.9,
      "vote_count": 7705
    };
    expect(result, expectedJsonMap);
  });
}
