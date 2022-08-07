import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlist(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(1))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(1);
    // assert
    verify(mockMovieRepository.removeWatchlist(1));
    expect(result, const Right('Removed from watchlist'));
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(1))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(1);
    // assert
    verify(mockMovieRepository.removeWatchlist(1));
    expect(result, const Right('Removed from watchlist'));
  });
}
