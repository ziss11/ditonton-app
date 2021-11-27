import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecase/get_movie_detail.dart';
import 'package:movie/domain/usecase/get_movie_recommendations.dart';

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
      emit(MovieRecommendationLoading());
      recommendation.fold(
        (failure) async {
          emit(MovieRecommendationError(failure.message));
        },
        (recommendation) async {
          emit(MovieDetailLoaded(detail, recommendation));
        },
      );
    });
  }
}
