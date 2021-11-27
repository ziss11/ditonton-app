import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

part 'search_tv_series_event.dart';
part 'search_tv_series_state.dart';

class SearchTvSeriesBloc
    extends Bloc<SearchTvSeriesEvent, SearchTvSeriesState> {
  final SearchTvSeries searchTvSeries;

  SearchTvSeriesBloc({required this.searchTvSeries})
      : super(SearchTvSeriesInitial()) {
    on<OnChangeTvQuery>((event, emit) async {
      final query = event.query;

      emit(SearchTvSeriesLoading());

      final result = await searchTvSeries.execute(query);

      result.fold(
        (failure) {
          emit(SearchTvSeriesError(failure.message));
        },
        (result) {
          emit(SearchTvSeriesHasData(result));
        },
      );
    }, transformer: _debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<OnChangeTvQuery> _debounce<OnChangeTvQuery>(
          Duration duration) =>
      (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
