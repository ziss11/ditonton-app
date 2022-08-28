import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_movie_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([
  MovieDetailCubit,
  WatchlistCubit,
])
void main() {
  late MockMovieDetailCubit mockMovieDetailCubit;
  late MockWatchlistCubit mockWatchlistCubit;

  setUp(() {
    mockWatchlistCubit = MockWatchlistCubit();
    mockMovieDetailCubit = MockMovieDetailCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>.value(
      value: mockMovieDetailCubit,
      child: BlocProvider<WatchlistCubit>.value(
        value: mockWatchlistCubit,
        child: MaterialApp(
          home: body,
        ),
      ),
    );
  }

  testWidgets(
    'should display proggress bar when movie and recommendation loading',
    (WidgetTester tester) async {
      when(mockMovieDetailCubit.stream)
          .thenAnswer((_) => Stream.value(MovieDetailLoading()));
      when(mockMovieDetailCubit.state).thenReturn(MovieDetailLoading());
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
      when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));

      final loadingFinder = find.byType(CircularProgressIndicator);

      await tester
          .pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
      expect(loadingFinder, findsOneWidget);
    },
  );

  testWidgets(
    'should display error message when get data is error',
    (WidgetTester tester) async {
      when(mockMovieDetailCubit.stream).thenAnswer(
          (_) => Stream.value(const MovieDetailError('Error Message')));
      when(mockMovieDetailCubit.state)
          .thenReturn(const MovieDetailError('Error Message'));
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
      when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));

      final errorFinder = find.text('Error Message');

      await tester
          .pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
      expect(errorFinder, findsOneWidget);
    },
  );

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailCubit.stream).thenAnswer((_) =>
        Stream.value(const MovieDetailLoaded(testMovieDetail, <Movie>[])));
    when(mockMovieDetailCubit.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail, <Movie>[]));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailCubit.stream).thenAnswer((_) =>
        Stream.value(const MovieDetailLoaded(testMovieDetail, <Movie>[])));
    when(mockMovieDetailCubit.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail, <Movie>[]));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(true)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailCubit.stream).thenAnswer(
        (_) => Stream.value(MovieDetailLoaded(testMovieDetail, testMovieList)));
    when(mockMovieDetailCubit.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail, testMovieList));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
    when(mockWatchlistCubit.stream).thenAnswer(
        (_) => Stream.value(const WatchlistMessage('Added to Watchlist')));
    when(mockWatchlistCubit.state)
        .thenReturn(const WatchlistMessage('Added to Watchlist'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailCubit.stream).thenAnswer(
        (_) => Stream.value(MovieDetailLoaded(testMovieDetail, testMovieList)));
    when(mockMovieDetailCubit.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail, testMovieList));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(true)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(true));
    when(mockWatchlistCubit.stream).thenAnswer(
        (_) => Stream.value(const WatchlistMessage('Removed from Watchlist')));
    when(mockWatchlistCubit.state)
        .thenReturn(const WatchlistMessage('Removed from Watchlist'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
    when(mockMovieDetailCubit.stream).thenAnswer(
        (_) => Stream.value(MovieDetailLoaded(testMovieDetail, testMovieList)));
    when(mockMovieDetailCubit.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail, testMovieList));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistMessage('Failed')));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistMessage('Failed'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when remove from watchlist failed',
      (WidgetTester tester) async {
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
    when(mockMovieDetailCubit.stream).thenAnswer(
        (_) => Stream.value(MovieDetailLoaded(testMovieDetail, testMovieList)));
    when(mockMovieDetailCubit.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail, testMovieList));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistMessage('Failed')));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistMessage('Failed'));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
