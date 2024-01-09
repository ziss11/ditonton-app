import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecase/get_top_rated_tv_series.dart';

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
