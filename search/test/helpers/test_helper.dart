import 'package:core/data/datasources/db/database_helper.dart';
import 'package:movie/data/datasource/movie_local_data_source.dart';
import 'package:movie/data/datasource/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:tv_series/data/datasource/tv_series_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

@GenerateMocks([
  TvSeriesRepository,
  TvSeriesRemoteDataSource,
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
