import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_series_top_rated_state.dart';

class TvSeriesTopRatedCubit extends Cubit<TvSeriesTopRatedState> {
  final GetTopRatedTvSeries topRatedTvSeries;

  TvSeriesTopRatedCubit({required this.topRatedTvSeries})
      : super(TvSeriesTopRatedInitial());

  void fetchTopRatedTv() async {
    emit(TvSeriesTopRatedLoading());

    final result = await topRatedTvSeries.execute();

    result.fold(
      (failure) async => emit(TvSeriesTopRatedError(failure.message)),
      (data) async => emit(TvSeriesTopRatedLoaded(data)),
    );
  }
}
