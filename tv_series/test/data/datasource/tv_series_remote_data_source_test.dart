import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tv_series/data/datasource/tv_series_remote_data_source.dart';
import 'package:tv_series/data/models/epidose_response.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_response.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockIOClient mockIOClient;

  setUp(() {
    mockIOClient = MockIOClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockIOClient);
  });

  const tId = 93405;

  group('Get Now Playing Tv Series List', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_now_playing.json')))
        .tvSeriesList;

    test(
        'should return Now Playing Tv Series List when response status code is 200',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/on_the_air?api_key=${dotenv.env['api_key']}')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_now_playing.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      //act
      final result = await dataSource.getNowPlayingTvSeries();
      //assert
      expect(result, tTvSeriesList);
    });

    test('should throw a Server Exception when response code is 404 or other',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/on_the_air?api_key=${dotenv.env['api_key']}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final call = dataSource.getNowPlayingTvSeries();
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Popular Tv Series List', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_popular.json')))
        .tvSeriesList;
    test(
        'should return Model of Tv Series Popular List when response status code is 200',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/popular?api_key=${dotenv.env['api_key']}')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_popular.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      //act
      final result = await dataSource.getPopularTvSeries();
      //assert
      expect(result, tTvSeriesList);
    });

    test('should throw a Server Exception when response code is 404 or other',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/popular?api_key=${dotenv.env['api_key']}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final call = dataSource.getPopularTvSeries();
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Recommended Tv Series List', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_recommendation.json')))
        .tvSeriesList;
    test('should return Recommended Tv Series List when response code is 200',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/$tId/recommendations?api_key=${dotenv.env['api_key']}')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_recommendation.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      //act
      final result = await dataSource.getRecommendationTvSeries(tId);
      //assert
      expect(result, tTvSeriesList);
    });

    test('should return Server Exception when response code is 404 or other',
        () {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/$tId/recommendations?api_key=${dotenv.env['api_key']}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final call = dataSource.getRecommendationTvSeries(tId);
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Detail Tv Series', () {
    final tTvSeriesDetail = TvSeriesDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv_series_detail.json')));

    test('should return Detail Tv Series when response body is 200', () async {
      //arrange
      when(mockIOClient.get(
              Uri.parse('$baseUrl/tv/$tId?api_key=${dotenv.env['api_key']}')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_detail.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      //act
      final result = await dataSource.getDetailTvSeries(tId);
      //assert
      expect(result, tTvSeriesDetail);
    });

    test('should return Server Exception when response body is 404 or other',
        () {
      //arrange
      when(mockIOClient.get(
              Uri.parse('$baseUrl/tv/$tId?api_key=${dotenv.env['api_key']}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final result = dataSource.getDetailTvSeries(tId);
      //assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('Search Tv Series List', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/search_tv_series.json')))
        .tvSeriesList;

    const tQuery = 'Squid Game';

    test('should return Searc Tv Series List when response code is 200',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/search/tv?api_key=${dotenv.env['api_key']}&query=$tQuery')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_tv_series.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      //act
      final result = await dataSource.searchTvSeries(tQuery);
      //assert
      expect(result, tTvSeriesList);
    });

    test('should return Server Exception when response body is 404 or other',
        () {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/search/tv?api_key=${dotenv.env['api_key']}&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final result = dataSource.searchTvSeries(tQuery);
      //assert
      expect(result, throwsA(isA<ServerException>()));
    });
  });

  group('Get Top Rated Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_top_rated.json')))
        .tvSeriesList;
    test('should return Searc Tv Series List when response code is 200',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/top_rated?api_key=${dotenv.env['api_key']}')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_top_rated.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      //act
      final result = await dataSource.getTopRatedTvSeries();
      //assert
      expect(result, tTvSeriesList);
    });
    test('should throw a Server Exception when response code is 404 or other',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/top_rated?api_key=${dotenv.env['api_key']}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final call = dataSource.getTopRatedTvSeries();
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Tv Series Episode', () {
    final tEpisodeList = EpisodeResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_episode.json')))
        .episodeList;
    const tSeason = 1;
    test('should return Searc Tv Series List when response code is 200',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/$tId/season/$tSeason?api_key=${dotenv.env['api_key']}')))
          .thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_series_episode.json'), 200),
      );
      //act
      final result = await dataSource.getTvSeriesEpisode(tId, tSeason);
      //assert
      expect(result, tEpisodeList);
    });
    test('should throw a Server Exception when response code is 404 or other',
        () async {
      //arrange
      when(mockIOClient.get(Uri.parse(
              '$baseUrl/tv/$tId/season/$tSeason?api_key=${dotenv.env['api_key']}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      //act
      final call = dataSource.getTvSeriesEpisode(tId, tSeason);
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
