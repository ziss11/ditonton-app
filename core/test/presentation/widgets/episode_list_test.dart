import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:core/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:core/presentation/widgets/episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../pages/tv_series/tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TvSeriesDetailNotifier])
void main() {
  late MockTvSeriesDetailNotifier mockTvSeriesDetailNotifier;

  setUp(() {
    mockTvSeriesDetailNotifier = MockTvSeriesDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockTvSeriesDetailNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "should display episode list when data is loaded",
    (WidgetTester tester) async {
      when(mockTvSeriesDetailNotifier.episodeState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeriesDetailNotifier.episodeTvSeries).thenReturn(<Episode>[]);

      final listFinder = find.byKey(const Key('episode_list'));

      await tester.pumpWidget(
          _makeTestableWidget(const EpisodeCardList(id: 1, season: 1)));

      expect(listFinder, findsOneWidget);
    },
  );
}
