import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:core/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:core/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:core/presentation/provider/watchlist_notifier.dart';
import 'package:core/presentation/widgets/episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import '../movie/movie_detail_page_test.mocks.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([
  TvSeriesDetailNotifier,
])
void main() {
  late MockTvSeriesDetailNotifier mockTvSeriesDetailNotifier;
  late MockWatchlistNotifier mockWatchlistNotifier;
  late MockMovieDetailNotifier mockMovieDetailNotifier;

  setUp(() {
    mockTvSeriesDetailNotifier = MockTvSeriesDetailNotifier();
    mockWatchlistNotifier = MockWatchlistNotifier();
    mockMovieDetailNotifier = MockMovieDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockMovieDetailNotifier,
      child: ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
        value: mockTvSeriesDetailNotifier,
        child: ChangeNotifierProvider<WatchlistNotifier>.value(
          value: mockWatchlistNotifier,
          child: MaterialApp(
            home: body,
          ),
        ),
      ),
    );
  }

  testWidgets(
    "Watchlist button should display add icon when tv series not added to watchlist",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);
      when(mockTvSeriesDetailNotifier.recommendedState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.recomendedTvSeries)
          .thenReturn(<TvSeries>[]);
      when(mockTvSeriesDetailNotifier.episodeState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
      when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester
          .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    "Watchlist button should display check icon when tv series added to watchlist",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);
      when(mockTvSeriesDetailNotifier.recommendedState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.recomendedTvSeries)
          .thenReturn(<TvSeries>[]);
      when(mockTvSeriesDetailNotifier.episodeState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
      when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester
          .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
      'Watchlist button should display snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockMovieDetailNotifier.watchlistMessage)
        .thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display snackbar when removed from watchlist',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockMovieDetailNotifier.watchlistMessage)
        .thenReturn('Removed from Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockMovieDetailNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when removed from watchlist failed',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockMovieDetailNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
    "should display Episode Card List Widget",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);
      when(mockTvSeriesDetailNotifier.recommendedState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.recomendedTvSeries)
          .thenReturn(<TvSeries>[]);
      when(mockTvSeriesDetailNotifier.episodeState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
      when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);

      final detailEpisodeCard = find.byType(EpisodeCardList);

      await tester
          .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(detailEpisodeCard, findsOneWidget);
    },
  );

  testWidgets(
      'Page should display center progress bar when recommendation is loading',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.loading);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);

    final loadingWidget = find.byKey(const Key('recommended_loading'));

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display recommendation ListView when data loaded',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);

    final listViewWidget = find.byKey(const Key('recommended_list'));

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(listViewWidget, findsOneWidget);
  });

  testWidgets('Page should display recommended error message when Error',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.error);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockTvSeriesDetailNotifier.message).thenReturn('Error message');

    final textWidget = find.byKey(const Key('recommended_error'));

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(textWidget, findsOneWidget);
  });

  testWidgets('should pop', (WidgetTester tester) async {
    when(mockTvSeriesDetailNotifier.tvSeriesState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.tvSeriesDetail)
        .thenReturn(testTvSeriesDetail);
    when(mockTvSeriesDetailNotifier.recommendedState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesDetailNotifier.recomendedTvSeries)
        .thenReturn(<TvSeries>[]);
    when(mockTvSeriesDetailNotifier.episodeState)
        .thenReturn(RequestState.error);
    when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
    when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockTvSeriesDetailNotifier.message).thenReturn('Success');

    final backButtonFinder = find.byIcon(Icons.arrow_back);

    await tester
        .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(backButtonFinder, findsOneWidget);

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    expect(backButtonFinder, findsNothing);
  });

  testWidgets(
    "should display data when tv is added to watchlist",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.tvSeriesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.tvSeriesDetail)
          .thenReturn(testTvSeriesDetail);
      when(mockTvSeriesDetailNotifier.recommendedState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.recomendedTvSeries)
          .thenReturn(<TvSeries>[]);
      when(mockTvSeriesDetailNotifier.episodeState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);
      when(mockMovieDetailNotifier.isAddedToWatchlist).thenReturn(true);

      final contentFinder = find.byType(DetailTvContent);

      await tester
          .pumpWidget(_makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(contentFinder, findsOneWidget);
    },
  );
}
