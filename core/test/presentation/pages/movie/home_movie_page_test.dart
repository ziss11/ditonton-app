import 'package:core/presentation/cubit/movie/movie_now_playing_cubit.dart';
import 'package:core/presentation/cubit/movie/movie_popular_cubit.dart';
import 'package:core/presentation/cubit/movie/movie_top_rated_cubit.dart';
import 'package:core/presentation/pages/movie/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_movie_objects.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks([
  MovieNowPlayingCubit,
  MoviePopularCubit,
  MovieTopRatedCubit,
])
void main() {
  late MockMovieNowPlayingCubit mockMovieNowPlayingCubit;
  late MockMoviePopularCubit mockMoviePopularCubit;
  late MockMovieTopRatedCubit mockMovieTopRatedCubit;

  setUp(() {
    mockMovieNowPlayingCubit = MockMovieNowPlayingCubit();
    mockMoviePopularCubit = MockMoviePopularCubit();
    mockMovieTopRatedCubit = MockMovieTopRatedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieNowPlayingCubit>.value(
      value: mockMovieNowPlayingCubit,
      child: BlocProvider<MoviePopularCubit>.value(
        value: mockMoviePopularCubit,
        child: BlocProvider<MovieTopRatedCubit>.value(
          value: mockMovieTopRatedCubit,
          child: MaterialApp(
            home: body,
          ),
        ),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockMovieNowPlayingCubit.stream)
        .thenAnswer((_) => Stream.value(MovieNowPlayingLoading()));
    when(mockMovieNowPlayingCubit.state).thenReturn(MovieNowPlayingLoading());
    when(mockMoviePopularCubit.stream)
        .thenAnswer((_) => Stream.value(MoviePopularLoading()));
    when(mockMoviePopularCubit.state).thenReturn(MoviePopularLoading());
    when(mockMovieTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(MovieTopRatedLoading()));
    when(mockMovieTopRatedCubit.state).thenReturn(MovieTopRatedLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byKey(const Key('center_progressbar'));

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(centerFinder, findsNWidgets(3));
    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockMovieNowPlayingCubit.stream)
        .thenAnswer((_) => Stream.value(MovieNowPlayingLoaded(testMovieList)));
    when(mockMovieNowPlayingCubit.state)
        .thenReturn(MovieNowPlayingLoaded(testMovieList));
    when(mockMoviePopularCubit.stream)
        .thenAnswer((_) => Stream.value(MoviePopularLoaded(testMovieList)));
    when(mockMoviePopularCubit.state)
        .thenReturn(MoviePopularLoaded(testMovieList));
    when(mockMovieTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(MovieTopRatedLoaded(testMovieList)));
    when(mockMovieTopRatedCubit.state)
        .thenReturn(MovieTopRatedLoaded(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(listViewFinder, findsNWidgets(3));
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockMovieNowPlayingCubit.stream)
        .thenAnswer((_) => Stream.value(const MovieNowPlayingError('Failed')));
    when(mockMovieNowPlayingCubit.state)
        .thenReturn(const MovieNowPlayingError('Failed'));
    when(mockMoviePopularCubit.stream)
        .thenAnswer((_) => Stream.value(const MoviePopularError('Failed')));
    when(mockMoviePopularCubit.state)
        .thenReturn(const MoviePopularError('Failed'));
    when(mockMovieTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(const MovieTopRatedError('Failed')));
    when(mockMovieTopRatedCubit.state)
        .thenReturn(const MovieTopRatedError('Failed'));

    final textFinder = find.text('Failed');

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(textFinder, findsNWidgets(3));
  });
}
