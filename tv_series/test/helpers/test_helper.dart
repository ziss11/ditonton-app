import 'package:http/io_client.dart';
import 'package:tv_series/data/datasource/tv_series_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

@GenerateMocks([
  TvSeriesRepository,
  TvSeriesRemoteDataSource,
], customMocks: [
  MockSpec<IOClient>(as: #MockIOClient)
])
void main() {}
