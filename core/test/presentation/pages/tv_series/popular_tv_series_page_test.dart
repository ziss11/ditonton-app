import 'package:core/presentation/cubit/tv_series/tv_series_popular_cubit.dart';
import 'package:core/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'popular_tv_series_page_test.mocks.dart';

@GenerateMocks([TvSeriesPopularCubit])
void main() {
  late MockTvSeriesPopularCubit mockCubit;

  setUp(() {
    mockCubit = MockTvSeriesPopularCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesPopularCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(TvSeriesPopularLoading()));
    when(mockCubit.state).thenReturn(TvSeriesPopularLoading());

    final loadingWidget = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(TvSeriesPopularLoaded(testTvSeriesList)));
    when(mockCubit.state).thenReturn(TvSeriesPopularLoaded(testTvSeriesList));

    final listViewWidget = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(listViewWidget, findsOneWidget);
  });

  testWidgets('Page should display error message when Error',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const TvSeriesPopularError('Error Message')));
    when(mockCubit.state)
        .thenReturn(const TvSeriesPopularError('Error Message'));

    final textWidget = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularTvSeriesPage()));

    expect(textWidget, findsOneWidget);
  });
}
