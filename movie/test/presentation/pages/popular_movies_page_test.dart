import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/cubit/movie_popular_cubit.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_movie_objects.dart';
import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([MoviePopularCubit])
void main() {
  late MockMoviePopularCubit mockCubit;

  setUp(() {
    mockCubit = MockMoviePopularCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MoviePopularCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(MoviePopularLoading()));
    when(mockCubit.state).thenReturn(MoviePopularLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(MoviePopularLoaded(testMovieList)));
    when(mockCubit.state).thenReturn(MoviePopularLoaded(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const MoviePopularError('Error Message')));
    when(mockCubit.state).thenReturn(const MoviePopularError('Error Message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
