import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_series_list_state.dart';

class TvSeriesListCubit extends Cubit<TvSeriesListState> {
  final GetNowPlayingTvSeries nowPlayingTvSeries;
  final GetPopularTvSeries popularTvSeries;
  final GetTopRatedTvSeries topRatedTvSeries;

  TvSeriesListCubit({
    required this.nowPlayingTvSeries,
    required this.popularTvSeries,
    required this.topRatedTvSeries,
  }) : super(TvSeriesListInitial());

  void fetchNowPlayingTv() async {
    emit(TvSeriesNowPlayingLoading());

    final result = await nowPlayingTvSeries.execute();

    result.fold(
      (failure) async {
        emit(TvSeriesNowPlayingError(failure.message));
      },
      (data) async {
        emit(TvSeriesNowPlayingLoaded(data));
      },
    );
  }

  void fetchPopularTv() async {
    emit(TvSeriesPopularLoading());

    final result = await popularTvSeries.execute();

    result.fold(
      (failure) async => emit(TvSeriesPopularError(failure.message)),
      (data) async => emit(TvSeriesPopularLoaded(data)),
    );
  }

  void fetchTopRatedTv() async {
    emit(TvSeriesTopRatedLoading());

    final result = await topRatedTvSeries.execute();

    result.fold(
      (failure) async => emit(TvSeriesTopRatedError(failure.message)),
      (data) async => emit(TvSeriesTopRatedLoaded(data)),
    );
  }
}
