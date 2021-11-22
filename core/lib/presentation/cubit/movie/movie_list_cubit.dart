import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies nowPlayingMovies;
  final GetPopularMovies popularMovies;
  final GetTopRatedMovies topRatedMovies;

  MovieListCubit({
    required this.nowPlayingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
  }) : super(MovieListInitial());

  void fetchNowPlayingMovie() async {
    emit(MovieNowPlayingLoading());

    final result = await nowPlayingMovies.execute();

    result.fold(
      (failure) async {
        emit(MovieNowPlayingError(failure.message));
      },
      (data) async {
        emit(MovieNowPlayingLoaded(data));
      },
    );
  }

  void fetchPopularMovie() async {
    emit(MoviePopularLoading());

    final result = await popularMovies.execute();

    result.fold(
      (failure) async {
        emit(MoviePopularError(failure.message));
      },
      (data) async {
        emit(MoviePopularLoaded(data));
      },
    );
  }

  void fetchTopRatedMovie() async {
    emit(MovieTopRatedLoading());

    final result = await topRatedMovies.execute();

    result.fold(
      (failure) async {
        emit(MovieTopRatedError(failure.message));
      },
      (data) async {
        emit(MovieTopRatedLoaded(data));
      },
    );
  }
}
