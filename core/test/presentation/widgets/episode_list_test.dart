import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_detail_cubit.dart';
import 'package:core/presentation/widgets/episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'episode_list_test.mocks.dart';

@GenerateMocks([TvSeriesDetailCubit])
void main() {
  late MockTvSeriesDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockTvSeriesDetailCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "should display episode list when data is loaded",
    (WidgetTester tester) async {
      when(mockCubit.stream).thenAnswer(
          (_) => Stream.value(TvSeriesEpisodeLoaded(testEpisodeList)));
      when(mockCubit.state).thenReturn(TvSeriesEpisodeLoaded(testEpisodeList));

      final listFinder = find.byKey(const Key('episode_list'));

      await tester.pumpWidget(
          _makeTestableWidget(const EpisodeCardList(id: 1, season: 1)));

      expect(listFinder, findsOneWidget);
    },
  );
}
