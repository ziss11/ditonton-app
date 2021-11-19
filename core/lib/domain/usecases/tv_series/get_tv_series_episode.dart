import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvSeriesEpisode {
  final TvSeriesRepository repository;

  GetTvSeriesEpisode(this.repository);

  Future<Either<Failure, List<Episode>>> execute(int id, int season) {
    return repository.getTvSeriesEpisode(id, season);
  }
}
