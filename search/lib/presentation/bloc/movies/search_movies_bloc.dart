import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:search/search.dart';
import 'package:rxdart/rxdart.dart';

part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMovies searchMovies;

  SearchMoviesBloc({required this.searchMovies})
      : super(SearchMoviesInitial()) {
    on<OnChangeMovieQuery>((event, emit) async {
      final query = event.query;

      emit(SearchMoviesLoading());

      final result = await searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(SearchMoviesError(failure.message));
        },
        (result) {
          emit(SearchMoviesHasData(result));
        },
      );
    }, transformer: _debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> _debounce<T>(
          Duration duration) =>
      (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}
