import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/cubit/tv_series/search_tv_series_cubit.dart';
import 'package:search/presentation/pages/tv_series/search_tv_series_page.dart';

import 'search_tv_series_page_test.mocks.dart';

@GenerateMocks([SearchTvSeriesCubit])
void main() {
  late MockSearchTvSeriesCubit mockCubit;

  setUp(() {
    mockCubit = MockSearchTvSeriesCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvSeriesCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(SearchTvSeriesLoading()));
    when(mockCubit.state).thenReturn(SearchTvSeriesLoading());

    final loadingWidget = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));

    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const SearchTvSeriesLoaded(<TvSeries>[])));
    when(mockCubit.state).thenReturn(const SearchTvSeriesLoaded(<TvSeries>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display empty message when data is empty',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(SearchTvSeriesInitial()));
    when(mockCubit.state).thenReturn(SearchTvSeriesInitial());

    final emptyMessage = find.byKey(const Key('empty_message'));

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));

    expect(emptyMessage, findsOneWidget);
  });
  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const SearchTvSeriesError('Error Message')));
    when(mockCubit.state)
        .thenReturn(const SearchTvSeriesError('Error Message'));

    final emptyMessage = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));

    expect(emptyMessage, findsOneWidget);
  });

  testWidgets('Page should display ListView when query id typed',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const SearchTvSeriesLoaded(<TvSeries>[])));
    when(mockCubit.state).thenReturn(const SearchTvSeriesLoaded(<TvSeries>[]));

    final textfieldFinder = find.byKey(const Key('query_input'));

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));
    await tester.enterText(textfieldFinder, 'Venom');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    verify(mockCubit.fetchSearchTvSeries('Venom'));
  });
}
