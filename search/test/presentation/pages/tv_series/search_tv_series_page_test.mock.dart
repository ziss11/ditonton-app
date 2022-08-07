import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/presentation/bloc/tv_series/search_tv_series_bloc.dart';

class MockSearchTvSeriesBloc
    extends MockBloc<SearchTvSeriesEvent, SearchTvSeriesState>
    implements SearchTvSeriesBloc {}

class SearchTvSeriesStateFake extends Fake implements SearchTvSeriesState {}

class SearchTvSeriesEventFake extends Fake implements SearchTvSeriesEvent {}
