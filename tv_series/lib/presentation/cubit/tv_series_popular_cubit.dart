import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecase/get_popular_tv_series.dart';

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
