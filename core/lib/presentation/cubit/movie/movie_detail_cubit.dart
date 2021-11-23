import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/movie/movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super(MovieDetailInitial());

  void fetchMovieDetail(int id) async {
    emit(MovieDetailLoading());

    final detail = await getMovieDetail.execute(id);
    final recommendation = await getMovieRecommendations.execute(id);

    detail.fold((failure) async {
      emit(MovieDetailError(failure.message));
    }, (detail) async {
      emit(MovieDetailLoading());
      recommendation.fold(
        (failure) async {
          emit(MovieDetailError(failure.message));
        },
        (recommendation) async {
          emit(MovieDetailLoaded(detail, recommendation));
        },
      );
    });
  }
}
