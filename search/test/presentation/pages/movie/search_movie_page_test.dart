import 'package:core/domain/entities/movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/cubit/movie/search_movies_cubit.dart';
import 'package:search/presentation/pages/movie/search_movie_page.dart';

import 'search_movie_page_test.mocks.dart';

@GenerateMocks([SearchMoviesCubit])
void main() {
  late MockSearchMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockSearchMoviesCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(SearchMoviesLoading()));
    when(mockCubit.state).thenReturn(SearchMoviesLoading());

    final loadingWidget = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

    expect(loadingWidget, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(const SearchMoviesLoaded(<Movie>[])));
    when(mockCubit.state).thenReturn(const SearchMoviesLoaded(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display empty message when data is empty',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(SearchMoviesInitial()));
    when(mockCubit.state).thenReturn(SearchMoviesInitial());

    final emptyMessage = find.byKey(const Key('empty_message'));

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

    expect(emptyMessage, findsOneWidget);
  });
  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const SearchMoviesError('Error Message')));
    when(mockCubit.state).thenReturn(const SearchMoviesError('Error Message'));

    final emptyMessage = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

    expect(emptyMessage, findsOneWidget);
  });

  testWidgets('Page should display ListView when query id typed',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(const SearchMoviesLoaded(<Movie>[])));
    when(mockCubit.state).thenReturn(const SearchMoviesLoaded(<Movie>[]));

    final textfieldFinder = find.byKey(const Key('query_input'));

    await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));
    await tester.enterText(textfieldFinder, 'Venom');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    verify(mockCubit.fetchSearchMovies('Venom'));
  });
}
