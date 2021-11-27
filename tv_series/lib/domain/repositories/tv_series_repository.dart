import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommended(int id);
  Future<Either<Failure, List<Episode>>> getTvSeriesEpisode(int id, int season);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
}
