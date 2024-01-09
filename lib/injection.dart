import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'package:movie/data/datasource/movie_local_data_source.dart';
import 'package:movie/data/datasource/movie_remote_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecase/get_movie_detail.dart';
import 'package:movie/domain/usecase/get_movie_recommendations.dart';
import 'package:movie/domain/usecase/get_now_playing_movies.dart';
import 'package:movie/domain/usecase/get_popular_movies.dart';
import 'package:movie/domain/usecase/get_top_rated_movies.dart';
import 'package:movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:movie/presentation/cubit/movie_now_playing_cubit.dart';
import 'package:movie/presentation/cubit/movie_popular_cubit.dart';
import 'package:movie/presentation/cubit/movie_top_rated_cubit.dart';
import 'package:search/search.dart';
import 'package:tv_series/data/datasource/tv_series_remote_data_source.dart';
import 'package:tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';
import 'package:tv_series/domain/usecase/get_detail_tv_series.dart';
import 'package:tv_series/domain/usecase/get_now_playing_tv_series.dart';
import 'package:tv_series/domain/usecase/get_popular_tv_series.dart';
import 'package:tv_series/domain/usecase/get_recommendation_tv_series.dart';
import 'package:tv_series/domain/usecase/get_top_rated_tv_series.dart';
import 'package:tv_series/domain/usecase/get_tv_series_episode.dart';
import 'package:tv_series/presentation/cubit/episode_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_now_playing_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_popular_cubit.dart';
import 'package:tv_series/presentation/cubit/tv_series_top_rated_cubit.dart';
import 'package:watchlist/watchlist.dart';

abstract class Injection {
  static void init(HttpClient httpClient) {
    // cubit
    GetIt.I.registerFactory(
      () => MovieNowPlayingCubit(
        nowPlayingMovies: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => MoviePopularCubit(
        popularMovies: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => MovieTopRatedCubit(
        topRatedMovies: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => MovieDetailCubit(
        getMovieDetail: GetIt.I(),
        getMovieRecommendations: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => SearchMoviesBloc(
        searchMovies: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => TvSeriesDetailCubit(
        detailTvSeries: GetIt.I(),
        recommendationTvSeries: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => EpisodeCubit(
        tvSeriesEpisode: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => TvSeriesNowPlayingCubit(
        nowPlayingTvSeries: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => TvSeriesTopRatedCubit(
        topRatedTvSeries: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => TvSeriesPopularCubit(
        popularTvSeries: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => SearchTvSeriesBloc(
        searchTvSeries: GetIt.I(),
      ),
    );
    GetIt.I.registerFactory(
      () => WatchlistCubit(
        watchlist: GetIt.I(),
        getWatchListStatus: GetIt.I(),
        removeWatchlist: GetIt.I(),
        saveWatchlist: GetIt.I(),
      ),
    );

    // use case
    GetIt.I.registerLazySingleton(() => GetNowPlayingMovies(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetPopularMovies(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetTopRatedMovies(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetMovieDetail(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetMovieRecommendations(GetIt.I()));
    GetIt.I.registerLazySingleton(() => SearchMovies(GetIt.I()));

    GetIt.I.registerLazySingleton(() => GetPopularTvSeries(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetNowPlayingTvSeries(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetRecommendationTvSeries(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetTvSeriesEpisode(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetDetailTvSeries(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetTopRatedTvSeries(GetIt.I()));
    GetIt.I.registerLazySingleton(() => SearchTvSeries(GetIt.I()));

    GetIt.I.registerLazySingleton(() => GetWatchListStatus(GetIt.I()));
    GetIt.I.registerLazySingleton(() => SaveWatchlist(GetIt.I()));
    GetIt.I.registerLazySingleton(() => RemoveWatchlist(GetIt.I()));
    GetIt.I.registerLazySingleton(() => GetWatchlist(GetIt.I()));

    // repository
    GetIt.I.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(
        remoteDataSource: GetIt.I(),
        localDataSource: GetIt.I(),
      ),
    );
    GetIt.I.registerLazySingleton<TvSeriesRepository>(
      () => TvSeriesRepositoryImpl(
        tvSeriesRemoteDataSource: GetIt.I(),
      ),
    );

    // data sources
    GetIt.I.registerLazySingleton<MovieRemoteDataSource>(
        () => MovieRemoteDataSourceImpl(client: GetIt.I()));
    GetIt.I.registerLazySingleton<MovieLocalDataSource>(
        () => MovieLocalDataSourceImpl(databaseHelper: GetIt.I()));
    GetIt.I.registerLazySingleton<TvSeriesRemoteDataSource>(
        () => TvSeriesRemoteDataSourceImpl(client: GetIt.I()));

    // helper
    GetIt.I.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

    // external
    GetIt.I.registerLazySingleton(() => IOClient(httpClient));
  }
}
