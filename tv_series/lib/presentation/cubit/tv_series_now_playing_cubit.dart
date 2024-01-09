import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecase/get_now_playing_tv_series.dart';

part 'tv_series_now_playing_state.dart';

class TvSeriesNowPlayingCubit extends Cubit<TvSeriesNowPlayingState> {
  final GetNowPlayingTvSeries nowPlayingTvSeries;

  TvSeriesNowPlayingCubit({
    required this.nowPlayingTvSeries,
  }) : super(TvSeriesNowPlayingInitial());

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
}
