import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/cubit/movie_top_rated_cubit.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';

import '../../dummy_data/dummy_movie_objects.dart';
import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([MovieTopRatedCubit])
void main() {
  late MockMovieTopRatedCubit mockCubit;

  setUp(() {
    mockCubit = MockMovieTopRatedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieTopRatedCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((realInvocation) => Stream.value(MovieTopRatedLoading()));
    when(mockCubit.state).thenReturn(MovieTopRatedLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (realInvocation) => Stream.value(MovieTopRatedLoaded(testMovieList)));
    when(mockCubit.state).thenReturn(MovieTopRatedLoaded(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer((realInvocation) =>
        Stream.value(const MovieTopRatedError('Error Message')));
    when(mockCubit.state).thenReturn(const MovieTopRatedError('Error Message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
