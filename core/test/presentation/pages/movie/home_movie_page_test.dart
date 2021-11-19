import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/presentation/pages/movie/home_movie_page.dart';
import 'package:core/presentation/provider/movie/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'home_movie_page_test.mocks.dart';

@GenerateMocks([MovieListNotifier])
void main() {
  late MockMovieListNotifier movieListNotifier;

  setUp(() {
    movieListNotifier = MockMovieListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieListNotifier>.value(
      value: movieListNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(movieListNotifier.nowPlayingState).thenReturn(RequestState.loading);
    when(movieListNotifier.popularMoviesState).thenReturn(RequestState.loading);
    when(movieListNotifier.topRatedMoviesState)
        .thenReturn(RequestState.loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(movieListNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(movieListNotifier.nowPlayingMovies).thenReturn(<Movie>[]);
    when(movieListNotifier.popularMoviesState).thenReturn(RequestState.loaded);
    when(movieListNotifier.popularMovies).thenReturn(<Movie>[]);
    when(movieListNotifier.topRatedMoviesState).thenReturn(RequestState.loaded);
    when(movieListNotifier.topRatedMovies).thenReturn(<Movie>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(listViewFinder, findsNWidgets(3));
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(movieListNotifier.nowPlayingState).thenReturn(RequestState.error);
    when(movieListNotifier.message).thenReturn('Error message');
    when(movieListNotifier.popularMoviesState).thenReturn(RequestState.error);
    when(movieListNotifier.message).thenReturn('Error message');
    when(movieListNotifier.topRatedMoviesState).thenReturn(RequestState.error);
    when(movieListNotifier.message).thenReturn('Error message');

    final textFinder = find.text('Failed');

    await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

    expect(textFinder, findsNWidgets(3));
  });
}
