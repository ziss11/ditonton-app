import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/search.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

import 'search_tv_series_page_test.mock.dart';

void main() {
  late MockSearchTvSeriesBloc mockTvBloc;

  setUpAll(() {
    registerFallbackValue(SearchTvSeriesStateFake());
    registerFallbackValue(SearchTvSeriesEventFake());
  });

  setUp(() {
    mockTvBloc = MockSearchTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvSeriesBloc>.value(
      value: mockTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvBloc.stream)
        .thenAnswer((_) => Stream.value(SearchTvSeriesLoading()));
    when(() => mockTvBloc.state).thenReturn(SearchTvSeriesLoading());

    final loadingWidget = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));

    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvBloc.state)
        .thenReturn(const SearchTvSeriesHasData(<TvSeries>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockTvBloc.state)
        .thenReturn(const SearchTvSeriesError('Error Message'));

    final emptyMessage = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));

    expect(emptyMessage, findsOneWidget);
  });

  testWidgets('Page should display ListView when query id typed',
      (WidgetTester tester) async {
    when(() => mockTvBloc.state)
        .thenReturn(const SearchTvSeriesHasData(<TvSeries>[]));

    final textfieldFinder = find.byKey(const Key('query_input'));

    await tester.pumpWidget(_makeTestableWidget(const SearchTvSeriesPage()));
    await tester.enterText(textfieldFinder, 'Venom');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    verify(() => mockTvBloc.add(const OnChangeTvQuery('Venom')));
  });
}
