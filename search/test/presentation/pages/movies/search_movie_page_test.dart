import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:search/search.dart';

import 'search_movie_page_test.mock.dart';

void main() {
  late MockSearchMoviesBloc mockMovieBloc;

  setUpAll(() {
    registerFallbackValue(SearchMoviesStateFake());
    registerFallbackValue(SearchMoviesEventFake());
  });

  setUp(() {
    mockMovieBloc = MockSearchMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchMoviesBloc>.value(
      value: mockMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieBloc.stream)
        .thenAnswer((_) => Stream.value(SearchMoviesLoading()));
    when(() => mockMovieBloc.state).thenReturn(SearchMoviesLoading());

    final loadingWidget = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockMovieBloc.state)
        .thenReturn(const SearchMoviesHasData(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockMovieBloc.state)
        .thenReturn(const SearchMoviesError('Error Message'));

    final emptyMessage = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

    expect(emptyMessage, findsOneWidget);
  });

  testWidgets('Page should display ListView when query id typed',
      (WidgetTester tester) async {
    when(() => mockMovieBloc.state)
        .thenReturn(const SearchMoviesHasData(<Movie>[]));

    final textfieldFinder = find.byKey(const Key('query_input'));

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));
    await tester.enterText(textfieldFinder, 'Venom');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    verify(() => mockMovieBloc.add(const OnChangeMovieQuery('Venom')));
  });
}
