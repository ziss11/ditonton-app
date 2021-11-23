import 'package:core/presentation/cubit/tv_series/tv_series_now_playing_cubit.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_popular_cubit.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_top_rated_cubit.dart';
import 'package:core/presentation/pages/tv_series/home_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'home_tv_series_page_test.mocks.dart';

@GenerateMocks([
  TvSeriesNowPlayingCubit,
  TvSeriesPopularCubit,
  TvSeriesTopRatedCubit,
])
void main() {
  late MockTvSeriesNowPlayingCubit mockTvSeriesNowPlayingCubit;
  late MockTvSeriesPopularCubit mockTvSeriesPopularCubit;
  late MockTvSeriesTopRatedCubit mockTvSeriesTopRatedCubit;

  setUp(() {
    mockTvSeriesNowPlayingCubit = MockTvSeriesNowPlayingCubit();
    mockTvSeriesPopularCubit = MockTvSeriesPopularCubit();
    mockTvSeriesTopRatedCubit = MockTvSeriesTopRatedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesNowPlayingCubit>.value(
      value: mockTvSeriesNowPlayingCubit,
      child: BlocProvider<TvSeriesPopularCubit>.value(
        value: mockTvSeriesPopularCubit,
        child: BlocProvider<TvSeriesTopRatedCubit>.value(
          value: mockTvSeriesTopRatedCubit,
          child: MaterialApp(
            home: body,
          ),
        ),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockTvSeriesNowPlayingCubit.stream)
        .thenAnswer((_) => Stream.value(TvSeriesNowPlayingLoading()));
    when(mockTvSeriesNowPlayingCubit.state)
        .thenReturn(TvSeriesNowPlayingLoading());
    when(mockTvSeriesPopularCubit.stream)
        .thenAnswer((_) => Stream.value(TvSeriesPopularLoading()));
    when(mockTvSeriesPopularCubit.state).thenReturn(TvSeriesPopularLoading());
    when(mockTvSeriesTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(TvSeriesTopRatedLoading()));
    when(mockTvSeriesTopRatedCubit.state).thenReturn(TvSeriesTopRatedLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byKey(const Key('center_progressbar'));

    await tester.pumpWidget(_makeTestableWidget(const HomeTvSeriesPage()));

    expect(centerFinder, findsNWidgets(3));
    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockTvSeriesNowPlayingCubit.stream).thenAnswer(
        (_) => Stream.value(TvSeriesNowPlayingLoaded(testTvSeriesList)));
    when(mockTvSeriesNowPlayingCubit.state)
        .thenReturn(TvSeriesNowPlayingLoaded(testTvSeriesList));
    when(mockTvSeriesPopularCubit.stream).thenAnswer(
        (_) => Stream.value(TvSeriesPopularLoaded(testTvSeriesList)));
    when(mockTvSeriesPopularCubit.state)
        .thenReturn(TvSeriesPopularLoaded(testTvSeriesList));
    when(mockTvSeriesTopRatedCubit.stream).thenAnswer(
        (_) => Stream.value(TvSeriesTopRatedLoaded(testTvSeriesList)));
    when(mockTvSeriesTopRatedCubit.state)
        .thenReturn(TvSeriesTopRatedLoaded(testTvSeriesList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const HomeTvSeriesPage()));

    expect(listViewFinder, findsNWidgets(3));
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockTvSeriesNowPlayingCubit.stream).thenAnswer(
        (_) => Stream.value(const TvSeriesNowPlayingError('Failed')));
    when(mockTvSeriesNowPlayingCubit.state)
        .thenReturn(const TvSeriesNowPlayingError('Failed'));
    when(mockTvSeriesPopularCubit.stream)
        .thenAnswer((_) => Stream.value(const TvSeriesPopularError('Failed')));
    when(mockTvSeriesPopularCubit.state)
        .thenReturn(const TvSeriesPopularError('Failed'));
    when(mockTvSeriesTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(const TvSeriesTopRatedError('Failed')));
    when(mockTvSeriesTopRatedCubit.state)
        .thenReturn(const TvSeriesTopRatedError('Failed'));

    final textFinder = find.text('Failed');

    await tester.pumpWidget(_makeTestableWidget(const HomeTvSeriesPage()));

    expect(textFinder, findsNWidgets(3));
  });
}
