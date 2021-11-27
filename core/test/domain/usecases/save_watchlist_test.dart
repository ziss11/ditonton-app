import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';

import '../../../../tv_series/test/dummy_data/dummy_tv_series_object.dart';
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

  final tMovie = Movie(
    type: 'Movie',
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 1,
    originalTitle: 'Spider-Man',
    overview: 'overview',
    popularity: 60.441,
    posterPath: 'posterPath',
    releaseDate: '2002-05-01',
    title: 'title',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  test('should save movie to the wathlist', () async {
    // arrange
    when(mockMovieRepository.saveWatchlist(tMovie))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(tMovie);
    // assert
    verify(mockMovieRepository.saveWatchlist(tMovie));
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
