import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecase/get_popular_movies.dart';

part 'movie_popular_state.dart';

class MoviePopularCubit extends Cubit<MoviePopularState> {
  final GetPopularMovies popularMovies;

  MoviePopularCubit({required this.popularMovies})
      : super(MoviePopularInitial());

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
}
