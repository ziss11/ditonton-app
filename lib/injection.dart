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

final locator = GetIt.instance;

void init(HttpClient httpClient) {
  // cubit
  locator.registerFactory(
    () => MovieNowPlayingCubit(
      nowPlayingMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MoviePopularCubit(
      popularMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieTopRatedCubit(
      topRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchMoviesBloc(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailCubit(
      detailTvSeries: locator(),
      recommendationTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => EpisodeCubit(
      tvSeriesEpisode: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesNowPlayingCubit(
      nowPlayingTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesTopRatedCubit(
      topRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesPopularCubit(
      popularTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchTvSeriesBloc(
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistCubit(
      watchlist: locator(),
      getWatchListStatus: locator(),
      removeWatchlist: locator(),
      saveWatchlist: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetRecommendationTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesEpisode(locator()));
  locator.registerLazySingleton(() => GetDetailTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));

  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlist(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      tvSeriesRemoteDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => IOClient(httpClient));
}
