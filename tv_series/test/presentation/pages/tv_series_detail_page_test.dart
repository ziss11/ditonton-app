import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/cubit/episode_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/presentation/widget/episode_card_list.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_tv_series_object.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([
  TvSeriesDetailCubit,
  WatchlistCubit,
  EpisodeCubit,
])
void main() {
  late MockTvSeriesDetailCubit mockTvSeriesDetailCubit;
  late MockWatchlistCubit mockWatchlistCubit;
  late MockEpisodeCubit mockEpisodeCubit;

  setUp(() {
    mockTvSeriesDetailCubit = MockTvSeriesDetailCubit();
    mockWatchlistCubit = MockWatchlistCubit();
    mockEpisodeCubit = MockEpisodeCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailCubit>.value(
      value: mockTvSeriesDetailCubit,
      child: BlocProvider<WatchlistCubit>.value(
        value: mockWatchlistCubit,
        child: BlocProvider<EpisodeCubit>.value(
          value: mockEpisodeCubit,
          child: MaterialApp(
            home: body,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'should display proggress bar when movie and recommendation loading',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailCubit.stream)
          .thenAnswer((_) => Stream.value(TvSeriesDetailLoading()));
      when(mockTvSeriesDetailCubit.state).thenReturn(TvSeriesDetailLoading());
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(WatchlistInitial()));
      when(mockWatchlistCubit.state).thenReturn(WatchlistInitial());

      final loadingFinder = find.byType(CircularProgressIndicator);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
      expect(loadingFinder, findsOneWidget);
    },
  );
  testWidgets(
    'should display error message when get data is error',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailCubit.stream).thenAnswer(
          (_) => Stream.value(const TvSeriesDetailError('Error Message')));
      when(mockTvSeriesDetailCubit.state)
          .thenReturn(const TvSeriesDetailError('Error Message'));
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(WatchlistInitial()));
      when(mockWatchlistCubit.state).thenReturn(WatchlistInitial());

      final errorFinder = find.text('Error Message');

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
      expect(errorFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Watchlist button should display add icon when tv series not added to watchlist",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailCubit.stream).thenAnswer((_) => Stream.value(
          const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[])));
      when(mockTvSeriesDetailCubit.state).thenReturn(
          const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[]));
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
      when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
      when(mockEpisodeCubit.stream)
          .thenAnswer((_) => Stream.value(EpisodeLoaded(testEpisodeList)));
      when(mockEpisodeCubit.state).thenReturn(EpisodeLoaded(testEpisodeList));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    "Watchlist button should display check icon when tv series added to watchlist",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailCubit.stream).thenAnswer((_) => Stream.value(
          const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[])));
      when(mockTvSeriesDetailCubit.state).thenReturn(
          const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[]));
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(const WatchlistStatus(true)));
      when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(true));
      when(mockEpisodeCubit.stream)
          .thenAnswer((_) => Stream.value(EpisodeLoaded(testEpisodeList)));
      when(mockEpisodeCubit.state).thenReturn(EpisodeLoaded(testEpisodeList));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
      'Watchlist button should display snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailCubit.stream).thenAnswer((_) => Stream.value(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[])));
    when(mockTvSeriesDetailCubit.state).thenReturn(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[]));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
    when(mockWatchlistCubit.stream).thenAnswer(
        (_) => Stream.value(const WatchlistMessage('Added to Watchlist')));
    when(mockWatchlistCubit.state)
        .thenReturn(const WatchlistMessage('Added to Watchlist'));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display snackbar when removed from watchlist',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailCubit.stream).thenAnswer((_) => Stream.value(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[])));
    when(mockTvSeriesDetailCubit.state).thenReturn(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[]));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(true)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(true));
    when(mockWatchlistCubit.stream).thenAnswer(
        (_) => Stream.value(const WatchlistMessage('Removed from Watchlist')));
    when(mockWatchlistCubit.state)
        .thenReturn(const WatchlistMessage('Removed from Watchlist'));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailCubit.stream).thenAnswer((_) => Stream.value(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[])));
    when(mockTvSeriesDetailCubit.state).thenReturn(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[]));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistMessage('Failed')));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistMessage('Failed'));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when removed from watchlist failed',
      (WidgetTester tester) async {
    when(mockTvSeriesDetailCubit.stream).thenAnswer((_) => Stream.value(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[])));
    when(mockTvSeriesDetailCubit.state).thenReturn(
        const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[]));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistStatus(true)));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(true));
    when(mockWatchlistCubit.stream)
        .thenAnswer((_) => Stream.value(const WatchlistMessage('Failed')));
    when(mockWatchlistCubit.state).thenReturn(const WatchlistMessage('Failed'));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
    "should display Episode Card List Widget",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailCubit.stream).thenAnswer((_) => Stream.value(
          const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[])));
      when(mockTvSeriesDetailCubit.state).thenReturn(
          const TvSeriesDetailLoaded(testTvSeriesDetail, <TvSeries>[]));
      when(mockWatchlistCubit.stream)
          .thenAnswer((_) => Stream.value(const WatchlistStatus(false)));
      when(mockWatchlistCubit.state).thenReturn(const WatchlistStatus(false));
      when(mockEpisodeCubit.stream)
          .thenAnswer((_) => Stream.value(EpisodeLoaded(testEpisodeList)));
      when(mockEpisodeCubit.state).thenReturn(EpisodeLoaded(testEpisodeList));

      final seasonTabbar = find.byType(TabBarView);
      final detailEpisodeCard = find.byType(EpisodeCardList);

      await tester
          .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

      expect(seasonTabbar, findsOneWidget);
      await tester.pump();

      expect(detailEpisodeCard, findsOneWidget);
    },
  );
}
