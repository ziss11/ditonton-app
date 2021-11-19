import 'dart:io';

import 'package:core/core.dart';
import 'package:core/data/models/tv_series/episode_model.dart';
import 'package:core/data/models/tv_series/genre_model.dart';
import 'package:core/data/models/tv_series/season_model.dart';
import 'package:core/data/models/tv_series/tv_series_detail_model.dart';
import 'package:core/data/models/tv_series/tv_series_model.dart';
import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_series/dummy_tv_series_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvSeriesRemoteDataSource mockTvSeriesRemoteDataSource;
  late TvSeriesRepositoryImpl repository;

  setUp(() {
    mockTvSeriesRemoteDataSource = MockTvSeriesRemoteDataSource();
    repository = TvSeriesRepositoryImpl(
      tvSeriesRemoteDataSource: mockTvSeriesRemoteDataSource,
    );
  });

  final tTvSeries = TvSeriesModel(
    type: 'Tv',
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    firstAirDate: '2021-09-17',
    id: 93405,
    ids: const [
      10759,
      9648,
      18,
    ],
    title: 'name',
    originCountry: const ['KR'],
    originalLanguage: 'ko',
    originalName: '오징어 게임',
    overview: 'overview',
    popularity: 6379.492,
    posterPath: 'posterPath',
    voteAverage: 7.9,
    voteCount: 7704,
  );

  const tEpisode = EpisodeModel(
    airDate: 'airDate',
    episodeNumber: 1,
    id: 1,
    name: "name",
    overview: "overview",
    seasonNumber: 0,
    stillPath: "stillPath",
    voteAverage: 0.0,
    voteCount: 0,
  );

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeries];
  final tEpisodeModelList = <EpisodeModel>[tEpisode];

  group('Now Playing Tv Series', () {
    test(
        'should return remote data when the call to remote data source is successful ',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      //act
      final result = await repository.getNowPlayingTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTvSeriesList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(ServerException());
      //act
      final result = await repository.getNowPlayingTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries());
      expect(result, const Left(ServerFailure('')));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getNowPlayingTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries());
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      //act
      final result = await repository.getTopRatedTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTvSeriesList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      //act
      final result = await repository.getTopRatedTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
      expect(result, const Left(ServerFailure('')));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getTopRatedTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Episode Tv Series', () {
    const tId = 1;
    const tSeason = 1;
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockTvSeriesRemoteDataSource.getTvSeriesEpisode(tId, tSeason))
          .thenAnswer((_) async => tEpisodeModelList);
      //act
      final result = await repository.getTvSeriesEpisode(tId, tSeason);
      //assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesEpisode(tId, tSeason));
      final resultList = result.getOrElse(() => []);
      expect(resultList, testEpisodeList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesEpisode(tId, tSeason))
          .thenThrow(ServerException());
      //act
      final result = await repository.getTvSeriesEpisode(tId, tSeason);
      //assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesEpisode(tId, tSeason));
      expect(result, const Left(ServerFailure('')));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesEpisode(tId, tSeason))
          .thenThrow(const SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getTvSeriesEpisode(tId, tSeason);
      //assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesEpisode(tId, tSeason));
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('Popular Tv Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      //act
      final result = await repository.getPopularTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTvSeriesList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      //act
      final result = await repository.getPopularTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
      expect(result, const Left(ServerFailure('')));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getPopularTvSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getPopularTvSeries();
      //assert
      verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Recommended Tv Series', () {
    const tId = 1;
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getRecommendationTvSeries(tId))
          .thenAnswer((_) async => tTvSeriesModelList);
      //act
      final result = await repository.getTvSeriesRecommended(tId);
      //assert
      verify(mockTvSeriesRemoteDataSource.getRecommendationTvSeries(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTvSeriesList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getRecommendationTvSeries(tId))
          .thenThrow(ServerException());
      //act
      final result = await repository.getTvSeriesRecommended(tId);
      //assert
      verify(mockTvSeriesRemoteDataSource.getRecommendationTvSeries(tId));
      expect(result, const Left(ServerFailure('')));
    });
    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getRecommendationTvSeries(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getTvSeriesRecommended(tId);
      //assert
      verify(mockTvSeriesRemoteDataSource.getRecommendationTvSeries(tId));
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Search Tv Series', () {
    const tQuery = 'Squid Game';
    test(
        'should return search tv series list when call to data source is successful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);
      //act
      final result = await repository.searchTvSeries(tQuery);
      //assert
      verify(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery));
      final resultList = result.getOrElse(() => []);
      expect(resultList, testTvSeriesList);
    });
    test('should return server exception when call remote is unsuccelful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());
      //act
      final result = await repository.searchTvSeries(tQuery);
      //assert
      verify(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery));
      expect(result, const Left(ServerFailure('')));
    });
    test('should return connection exception when call remote is unsuccesful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      //act
      final result = await repository.searchTvSeries(tQuery);
      //assert
      verify(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery));
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Detail Tv Series', () {
    const tId = 1;
    final tTvSeriesDetailModel = TvSeriesDetailModel(
      type: 'Tv',
      backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
      episodeRunTime: [54],
      firstAirDate: '2021-09-17',
      genres: const [
        GenreModel(
          id: 10759,
          name: 'Action & Adventure',
        ),
      ],
      id: 1,
      languages: ["en", "el"],
      lastAirDate: '2021-09-17',
      title: 'name',
      numberOfEpisode: 9,
      numberOfSeason: 1,
      originCountry: const ['KR'],
      originalLanguage: 'ko',
      originalName: '오징어 게임',
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
      tagline: '45.6 billion won is child\'s play.',
      voteAverage: 7.9,
      voteCount: 7705,
      homePage: 'homePage',
      inProduction: false,
      lastEpisodeToAir: const EpisodeModel(
        airDate: 'airDate',
        episodeNumber: 0,
        id: 0,
        name: "name",
        overview: "overview",
        seasonNumber: 0,
        stillPath: "stillPath",
        voteAverage: 0.0,
        voteCount: 0,
      ),
    );

    test(
        'should return details tv series list when call to data source is successful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getDetailTvSeries(tId))
          .thenAnswer((_) async => tTvSeriesDetailModel);
      //act
      final result = await repository.getTvSeriesDetail(tId);
      //assert
      verify(mockTvSeriesRemoteDataSource.getDetailTvSeries(tId));
      expect(result, const Right(testTvSeriesDetail));
    });
    test('should return server exception when call remote is unsuccesful',
        () async {
      //assert
      when(mockTvSeriesRemoteDataSource.getDetailTvSeries(tId))
          .thenThrow(ServerException());
      //act
      final result = await repository.getTvSeriesDetail(tId);
      //assert
      verify(mockTvSeriesRemoteDataSource.getDetailTvSeries(tId));
      expect(result, const Left(ServerFailure('')));
    });

    test('should return connection exception when call remote is unsuccesful',
        () async {
      //arrange
      when(mockTvSeriesRemoteDataSource.getDetailTvSeries(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      //act
      final result = await repository.getTvSeriesDetail(tId);
      //assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
}
