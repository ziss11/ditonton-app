import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/cubit/movie/movie_detail_cubit.dart';
import 'package:core/presentation/cubit/watchlist_cubit.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_movie_objects.dart';
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
    'should display proggress bar when movie loading',
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
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockMovieDetailCubit.stream).thenAnswer(
        (_) => Stream.value(const MovieDetailLoaded(testMovieDetail)));
    when(mockMovieDetailCubit.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
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
    when(mockMovieDetailCubit.stream).thenAnswer(
        (_) => Stream.value(const MovieDetailLoaded(testMovieDetail)));
    when(mockMovieDetailCubit.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
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
    when(mockMovieDetailCubit.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
    whenListen(
      mockWatchlistCubit,
      Stream.fromIterable([
        MovieDetailLoading(),
        const WatchlistMessage('Added to Watchlist'),
      ]),
      initialState: MovieDetailInitial(),
    );
    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  // testWidgets(
  //     'Watchlist button should display Snackbar when removed to watchlist',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movie).thenReturn(testMovieDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(true);
  //   when(mockNotifier.watchlistMessage).thenReturn('Removed from Watchlist');

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

  //   expect(find.byIcon(Icons.check), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byType(SnackBar), findsOneWidget);
  //   expect(find.text('Removed from Watchlist'), findsOneWidget);
  // });

  // testWidgets(
  //     'Watchlist button should display AlertDialog when add to watchlist failed',
  //     (WidgetTester tester) async {
  //   when(mockWatchlistCubit.stream)
  //       .thenAnswer((_) => Stream.value(const WatchlistMessage('Failed')));
  //   when(mockWatchlistCubit.state).thenReturn(const WatchlistMessage('Failed'));
  //   when(mockWatchlistCubit.stream)
  //       .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
  //   when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
  //   when(mockMovieDetailCubit.stream).thenAnswer(
  //       (_) => Stream.value(const MovieDetailLoaded(testMovieDetail)));
  //   when(mockMovieDetailCubit.state)
  //       .thenReturn(const MovieDetailLoaded(testMovieDetail));

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

  //   expect(find.byIcon(Icons.add), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });

  // testWidgets(
  //     'Watchlist button should display AlertDialog when remove from watchlist failed',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movie).thenReturn(testMovieDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(true);
  //   when(mockNotifier.watchlistMessage).thenReturn('Failed');

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

  //   expect(find.byIcon(Icons.check), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });

  testWidgets(
    'should display progress bar when recommendation loading',
    (WidgetTester tester) async {
      when(mockMovieDetailCubit.stream)
          .thenAnswer((_) => Stream.value(MovieRecommendationLoading()));
      when(mockMovieDetailCubit.state).thenReturn(MovieRecommendationLoading());
      when(mockMovieDetailCubit.stream).thenAnswer(
          (_) => Stream.value(const MovieDetailLoaded(testMovieDetail)));
      when(mockMovieDetailCubit.state)
          .thenReturn(const MovieDetailLoaded(testMovieDetail));
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
      when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));

      final loadingFinder = find.byType(CircularProgressIndicator);

      await tester
          .pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
      expect(loadingFinder, findsOneWidget);
    },
  );

  // testWidgets('Page should display recommendation ListView when data loaded',
  //     (WidgetTester tester) async {
  //   when(mockMovieDetailCubit.stream).thenAnswer(
  //       (_) => Stream.value(const MovieDetailLoaded(testMovieDetail)));
  //   when(mockMovieDetailCubit.state)
  //       .thenReturn(const MovieDetailLoaded(testMovieDetail));
  //   when(mockMovieDetailCubit.stream).thenAnswer(
  //       (_) => Stream.value(MovieRecommendationLoaded(testMovieList)));
  //   when(mockMovieDetailCubit.state)
  //       .thenReturn(MovieRecommendationLoaded(testMovieList));
  //   when(mockWatchlistCubit.stream)
  //       .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
  //   when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));

  //   final listViewWidget = find.byKey(const Key('recommended_list'));

  //   await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

  //   expect(listViewWidget, findsOneWidget);
  // });

  // testWidgets('Page should display recommended error message when Error',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.loaded);
  //   when(mockNotifier.movie).thenReturn(testMovieDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.error);
  //   when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(true);
  //   when(mockNotifier.message).thenReturn('Error message');

  //   final textWidget = find.byKey(const Key('recommended_error'));

  //   await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

  //   expect(textWidget, findsOneWidget);
  // });

  // testWidgets('should pop', (WidgetTester tester) async {
  //   when(mockMovieDetailCubit.stream).thenAnswer(
  //       (_) => Stream.value(const MovieDetailLoaded(testMovieDetail)));
  //   when(mockMovieDetailCubit.state)
  //       .thenReturn(const MovieDetailLoaded(testMovieDetail));
  //   when(mockMovieDetailCubit.stream).thenAnswer(
  //       (_) => Stream.value(MovieRecommendationLoaded(testMovieList)));
  //   when(mockMovieDetailCubit.state)
  //       .thenReturn(MovieRecommendationLoaded(testMovieList));
  //   when(mockWatchlistCubit.stream)
  //       .thenAnswer((_) => Stream.value(const WatchlistStatus(true)));
  //   when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(true));

  //   final backButtonFinder = find.byKey(const Key('back_from_detail'));

  //   await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

  //   expect(backButtonFinder, findsOneWidget);

  //   await tester.tap(backButtonFinder);
  //   await tester.pumpAndSettle();

  //   expect(backButtonFinder, findsNothing);
  // });
}
