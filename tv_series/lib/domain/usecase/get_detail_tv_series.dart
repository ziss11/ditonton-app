import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

class GetDetailTvSeries {
  final TvSeriesRepository repository;

  GetDetailTvSeries(this.repository);

  Future<Either<Failure, TvSeriesDetail>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}
