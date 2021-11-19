import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/movie/dummy_movie_objects.dart';
import '../../dummy_data/tv_series/dummy_tv_series_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlist(
      mockMovieRepository,
    );
  });

  test('should save movie to the wathlist', () async {
    // arrange
    when(mockMovieRepository.saveWatchlist(testMovie))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testMovie);
    // assert
    verify(mockMovieRepository.saveWatchlist(testMovie));
    expect(result, const Right('Added to Watchlist'));
  });

  test('should save tv series to the wathlist', () async {
    final tTvSeries = Movie.watchlist(
      id: testTvSeries.id!,
      overview: testTvSeries.overview,
      posterPath: testTvSeries.posterPath,
      title: testTvSeries.title,
      type: testTvSeries.type,
    );
    // arrange
    when(mockMovieRepository.saveWatchlist(tTvSeries))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesToMovie);
    // assert
    verify(mockMovieRepository.saveWatchlist(tTvSeries));
    expect(result, const Right('Added to Watchlist'));
  });
}
