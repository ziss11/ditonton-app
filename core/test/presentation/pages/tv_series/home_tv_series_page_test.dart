import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/presentation/pages/tv_series/home_tv_series_page.dart';
import 'package:core/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'now_playing_tv_series_test.mocks.dart';

@GenerateMocks([TvSeriesListNotifier])
void main() {
  late MockTvSeriesListNotifier tvSeriesListNotifier;

  setUp(() {
    tvSeriesListNotifier = MockTvSeriesListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesListNotifier>.value(
      value: tvSeriesListNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(tvSeriesListNotifier.nowPlayingState).thenReturn(RequestState.loading);
    when(tvSeriesListNotifier.popularTvSeriessState)
        .thenReturn(RequestState.loading);
    when(tvSeriesListNotifier.topTvRatedSeriesState)
        .thenReturn(RequestState.loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const HomeTvSeriesPage()));

    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(tvSeriesListNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(tvSeriesListNotifier.nowPlayingTvSeriess).thenReturn(<TvSeries>[]);
    when(tvSeriesListNotifier.popularTvSeriessState)
        .thenReturn(RequestState.loaded);
    when(tvSeriesListNotifier.popularTvSeriess).thenReturn(<TvSeries>[]);
    when(tvSeriesListNotifier.topTvRatedSeriesState)
        .thenReturn(RequestState.loaded);
    when(tvSeriesListNotifier.topRatedTvSeries).thenReturn(<TvSeries>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const HomeTvSeriesPage()));

    expect(listViewFinder, findsNWidgets(3));
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(tvSeriesListNotifier.nowPlayingState).thenReturn(RequestState.error);
    when(tvSeriesListNotifier.message).thenReturn('Error message');
    when(tvSeriesListNotifier.popularTvSeriessState)
        .thenReturn(RequestState.error);
    when(tvSeriesListNotifier.message).thenReturn('Error message');
    when(tvSeriesListNotifier.topTvRatedSeriesState)
        .thenReturn(RequestState.error);
    when(tvSeriesListNotifier.message).thenReturn('Error message');

    final textFinder = find.text('Failed');

    await tester.pumpWidget(_makeTestableWidget(const HomeTvSeriesPage()));

    expect(textFinder, findsNWidgets(3));
  });
}
