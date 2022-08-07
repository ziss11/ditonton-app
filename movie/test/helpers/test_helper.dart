import 'package:core/data/datasources/db/database_helper.dart';
import 'package:http/io_client.dart';
import 'package:movie/data/datasource/movie_local_data_source.dart';
import 'package:movie/data/datasource/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper
], customMocks: [
  MockSpec<IOClient>(as: #MockIOClient)
])
void main() {}
