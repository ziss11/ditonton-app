import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/movie/search_movies.dart';

import '../../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late SearchMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchMovies(mockMovieRepository);
  });

  const String tQuery = 'Squid Game';
  final tMovie = <Movie>[];

  test('should return search tv series list', () async {
    //arrange
    when(mockMovieRepository.searchMovies(tQuery))
        .thenAnswer((_) async => Right(tMovie));
    //act
    final result = await usecase.execute(tQuery);
    //assert
    expect(result, Right(tMovie));
  });
}
