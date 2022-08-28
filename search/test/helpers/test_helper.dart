import 'package:mockito/annotations.dart';
import 'package:movie/data/datasource/movie_local_data_source.dart';
import 'package:movie/data/datasource/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:tv_series/data/datasource/tv_series_remote_data_source.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

@GenerateMocks([
  TvSeriesRepository,
  TvSeriesRemoteDataSource,
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
])
void main() {}
