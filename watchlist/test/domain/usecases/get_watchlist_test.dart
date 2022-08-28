import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:watchlist/watchlist.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlist(mockMovieRepository);
  });

  final tMovie = Movie.watchlist(
    type: 'Movie',
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
  );

  final tTvSeriesToMovie = Movie.watchlist(
    type: 'Tv',
    id: 1,
    overview: "overview",
    posterPath: "posterPath",
    title: "title",
  );

  final tMovieList = [tMovie];
  final tTvSeriesList = [tTvSeriesToMovie];
  test('should get list of movies from the repository', () async {
    // arrange
    when(mockMovieRepository.getWatchlist())
        .thenAnswer((_) async => Right(tMovieList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovieList));
  });
  test('should get list of tv series from the repository', () async {
    //arrange
    when(mockMovieRepository.getWatchlist())
        .thenAnswer((_) async => Right(tTvSeriesList));
    //act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvSeriesList));
  });
}
