import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_now_playing_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies nowPlayingMovies;

  MovieListCubit({
    required this.nowPlayingMovies,
  }) : super(MovieNowPlayingInitial());

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
}
