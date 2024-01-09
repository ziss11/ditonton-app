import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../../../tv_series/test/dummy_data/dummy_tv_series_object.dart';
import 'watclhlist_page_test.mocks.dart';

@GenerateMocks([WatchlistCubit])
void main() {
  late MockWatchlistCubit mockCubit;

  setUp(() {
    mockCubit = MockWatchlistCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.stream)
        .thenAnswer((_) => Stream.value(WatchlistLoaded(testTvSeriesList)));
    when(mockCubit.state).thenReturn(WatchlistLoaded(testTvSeriesList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(const WatchlistMessage('Error Message')));
    when(mockCubit.state).thenReturn(const WatchlistMessage('Error Message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when data is empty',
      (WidgetTester tester) async {
    when(mockCubit.stream).thenAnswer((_) => Stream.value(WatchlistInitial()));
    when(mockCubit.state).thenReturn(WatchlistInitial());

    final textFinder = find.byKey(const Key('empty_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(textFinder, findsOneWidget);
  });
}
