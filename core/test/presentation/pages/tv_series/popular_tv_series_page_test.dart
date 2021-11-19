import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:core/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'popular_tv_series_page_test.mocks.dart';

@GenerateMocks([TvSeriesListNotifier])
void main() {
  late MockTvSeriesListNotifier mockTvSeriesListNotifier;

  setUp(() {
    mockTvSeriesListNotifier = MockTvSeriesListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesListNotifier>.value(
      value: mockTvSeriesListNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockTvSeriesListNotifier.popularTvSeriessState)
        .thenReturn(RequestState.loading);

    final loadingWidget = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockTvSeriesListNotifier.popularTvSeriessState)
        .thenReturn(RequestState.loaded);
    when(mockTvSeriesListNotifier.popularTvSeriess).thenReturn(<TvSeries>[]);

    final listViewWidget = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(listViewWidget, findsOneWidget);
  });

  testWidgets('Page should display error message when Error',
      (WidgetTester tester) async {
    when(mockTvSeriesListNotifier.popularTvSeriessState)
        .thenReturn(RequestState.error);
    when(mockTvSeriesListNotifier.message).thenReturn('Error message');

    final textWidget = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(textWidget, findsOneWidget);
  });
}
