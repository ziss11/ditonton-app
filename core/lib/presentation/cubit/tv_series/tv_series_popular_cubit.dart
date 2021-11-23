import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_series_popular_state.dart';

class TvSeriesPopularCubit extends Cubit<TvSeriesPopularState> {
  final GetPopularTvSeries popularTvSeries;

  TvSeriesPopularCubit({required this.popularTvSeries})
      : super(TvSeriesPopularInitial());

  void fetchPopularTv() async {
    emit(TvSeriesPopularLoading());

    final result = await popularTvSeries.execute();

    result.fold(
      (failure) async => emit(TvSeriesPopularError(failure.message)),
      (data) async => emit(TvSeriesPopularLoaded(data)),
    );
  }
}
