import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/search.dart';

class MockSearchMoviesBloc
    extends MockBloc<SearchMoviesEvent, SearchMoviesState>
    implements SearchMoviesBloc {}

class SearchMoviesStateFake extends Fake implements SearchMoviesState {}

class SearchMoviesEventFake extends Fake implements SearchMoviesEvent {}
