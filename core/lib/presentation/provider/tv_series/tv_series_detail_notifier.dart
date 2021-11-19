import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/entities/tv_series/tv_series_detail.dart';
import 'package:core/domain/usecases/tv_series/get_detail_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_recommendation_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_episode.dart';
import 'package:flutter/cupertino.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  final GetDetailTvSeries getDetailTvSeries;
  final GetRecommendationTvSeries getRecommendationTvSeries;
  final GetTvSeriesEpisode getTvSeriesEpisode;

  TvSeriesDetailNotifier({
    required this.getDetailTvSeries,
    required this.getRecommendationTvSeries,
    required this.getTvSeriesEpisode,
  });

  late TvSeriesDetail _tvSeriesDetail;
  TvSeriesDetail get tvSeriesDetail => _tvSeriesDetail;

  RequestState _tvSeriesState = RequestState.empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<TvSeries> _recommendedTvSeries = [];
  List<TvSeries> get recomendedTvSeries => _recommendedTvSeries;

  RequestState _recommendedState = RequestState.empty;
  RequestState get recommendedState => _recommendedState;

  List<Episode> _episodeTvSeries = [];
  List<Episode> get episodeTvSeries => _episodeTvSeries;

  RequestState _episodeState = RequestState.empty;
  RequestState get episodeState => _episodeState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesState = RequestState.loading;
    notifyListeners();

    final tvSeriesDetail = await getDetailTvSeries.execute(id);
    final recommendedTvSeries = await getRecommendationTvSeries.execute(id);

    tvSeriesDetail.fold(
      (failure) {
        _tvSeriesState = RequestState.error;

        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesDetail) {
        _recommendedState = RequestState.loading;

        _tvSeriesDetail = tvSeriesDetail;
        notifyListeners();

        recommendedTvSeries.fold(
          (failure) {
            _recommendedState = RequestState.error;
            _message = failure.message;
          },
          (recommendedTvSeries) {
            _recommendedState = RequestState.loaded;
            _recommendedTvSeries = recommendedTvSeries;
          },
        );
        _tvSeriesState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvSeriesEpisode(int id, int season) async {
    _episodeState = RequestState.loading;
    notifyListeners();

    final episodeTvSeries = await getTvSeriesEpisode.execute(id, season);

    episodeTvSeries.fold(
      (failure) {
        _episodeState = RequestState.error;

        _message = failure.message;
        notifyListeners();
      },
      (episode) {
        _episodeState = RequestState.loaded;

        _episodeTvSeries = episode;
        notifyListeners();
      },
    );
  }
}
