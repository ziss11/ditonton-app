import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/cubit/episode_cubit.dart';
import 'package:tv_series/presentation/widget/episode_card_list.dart';

import '../../../../tv_series/test/dummy_data/dummy_tv_series_object.dart';
import 'episode_list_test.mocks.dart';

@GenerateMocks([EpisodeCubit])
void main() {
  late MockEpisodeCubit mockCubit;

  setUp(() {
    mockCubit = MockEpisodeCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<EpisodeCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "Page should display message when data is empty",
    (WidgetTester tester) async {
      when(mockCubit.stream).thenAnswer((_) => Stream.value(EpisodeInitial()));
      when(mockCubit.state).thenReturn(EpisodeInitial());

      final messageFinder = find.byKey(const Key('empty_message'));

      await tester.pumpWidget(
          makeTestableWidget(const EpisodeCardList(id: 1, season: 1)));

      expect(messageFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Page should display progress bar when loading",
    (WidgetTester tester) async {
      when(mockCubit.stream).thenAnswer((_) => Stream.value(EpisodeLoading()));
      when(mockCubit.state).thenReturn(EpisodeLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
          makeTestableWidget(const EpisodeCardList(id: 1, season: 1)));

      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Page should display episode list when data is loaded",
    (WidgetTester tester) async {
      when(mockCubit.stream)
          .thenAnswer((_) => Stream.value(EpisodeLoaded(testEpisodeList)));
      when(mockCubit.state).thenReturn(EpisodeLoaded(testEpisodeList));

      final listFinder = find.byKey(const Key('episode_list'));

      await tester.pumpWidget(
          makeTestableWidget(const EpisodeCardList(id: 1, season: 1)));

      expect(listFinder, findsOneWidget);
    },
  );
}
