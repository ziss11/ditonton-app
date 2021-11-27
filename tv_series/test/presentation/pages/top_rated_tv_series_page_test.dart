import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/cubit/tv_series_top_rated_cubit.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';

import '../../dummy_data/dummy_tv_series_object.dart';
import 'top_rated_tv_series_page_test.mocks.dart';

@GenerateMocks([TvSeriesTopRatedCubit])
void main() {
  late MockTvSeriesTopRatedCubit mockCubit;

  setUp(() {
    mockCubit = MockTvSeriesTopRatedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesTopRatedCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(TvSeriesTopRatedLoading()));
    when(mockCubit.state).thenReturn(TvSeriesTopRatedLoading());

    final loadingWidget = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display ListView when data loaded',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(TvSeriesTopRatedLoaded(testTvSeriesList)));
    when(mockCubit.state).thenReturn(TvSeriesTopRatedLoaded(testTvSeriesList));

    final listViewWidget = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(listViewWidget, findsOneWidget);
  });

  testWidgets('Page should display error message when Error',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const TvSeriesTopRatedError('Error Message')));
    when(mockCubit.state)
        .thenReturn(const TvSeriesTopRatedError('Error Message'));

    final textWidget = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(textWidget, findsOneWidget);
  });
}
