import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:search/domain/usecases/movie/search_movies.dart';

part 'search_movies_state.dart';

class SearchMoviesCubit extends Cubit<SearchMoviesState> {
  final SearchMovies searchMovies;

  SearchMoviesCubit({required this.searchMovies})
      : super(SearchMoviesInitial());

  void fetchSearchMovies(String query) async {
    emit(SearchMoviesLoading());

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) async => emit(SearchMoviesError(failure.message)),
      (data) async {
        if (data.isNotEmpty) {
          emit(SearchMoviesLoaded(data));
        } else {
          emit(SearchMoviesInitial());
        }
      },
    );
  }
}
