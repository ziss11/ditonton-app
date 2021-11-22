import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';

part 'search_tv_series_state.dart';

class SearchTvSeriesCubit extends Cubit<SearchTvSeriesState> {
  final SearchTvSeries searchTvSeries;

  SearchTvSeriesCubit({
    required this.searchTvSeries,
  }) : super(SearchTvSeriesInitial());

  void fetchSearchTvSeries(String query) async {
    emit(SearchTvSeriesLoading());

    final result = await searchTvSeries.execute(query);

    result.fold(
      (failure) => emit(
        SearchTvSeriesError(failure.message),
      ),
      (data) async {
        if (data.isNotEmpty) {
          emit(SearchTvSeriesLoaded(data));
        } else {
          emit(SearchTvSeriesInitial());
        }
      },
    );
  }
}
