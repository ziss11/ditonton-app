import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/movie/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailCubit(
    this.getMovieDetail,
    this.getMovieRecommendations,
    this.getWatchListStatus,
    this.removeWatchlist,
    this.saveWatchlist,
  ) : super(MovieDetailInitial());

  void fetchMovieDetail(int id) async {
    emit(MovieDetailLoading());

    final detail = await getMovieDetail.execute(id);
    final recommendation = await getMovieRecommendations.execute(id);

    detail.fold((failure) async {
      emit(MovieDetailError(failure.message));
    }, (detail) async {
      emit(MovieDetailLoaded(detail));
      emit(MovieRecommendationLoading());
      recommendation.fold(
        (failure) async {
          emit(MovieRecommendationError(failure.message));
        },
        (data) async {
          emit(MovieRecommendationLoaded(data));
        },
      );
    });
  }

  void loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(WatchlistStatus(result));
  }

  void addWatchlist(Movie movie) async {
    final result = await saveWatchlist.execute(movie);
    await result.fold(
      (failure) async {
        emit(WatchlistMessage(failure.message));
      },
      (message) async {
        emit(WatchlistMessage(message));
      },
    );

    loadWatchlistStatus(movie.id);
  }

  void deleteWatchlist(int id) async {
    final result = await removeWatchlist.execute(id);
    await result.fold(
      (failure) async {
        emit(WatchlistMessage(failure.message));
      },
      (message) async {
        emit(WatchlistMessage(message));
      },
    );

    loadWatchlistStatus(id);
  }
}
