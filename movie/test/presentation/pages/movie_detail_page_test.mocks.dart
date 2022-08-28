// Mocks generated by Mockito 5.3.0 from annotations
// in movie/test/presentation/pages/movie_detail_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i10;

import 'package:bloc/bloc.dart' as _i11;
import 'package:mockito/mockito.dart' as _i1;
import 'package:movie/domain/entities/movie.dart' as _i12;
import 'package:movie/domain/usecase/get_movie_detail.dart' as _i2;
import 'package:movie/domain/usecase/get_movie_recommendations.dart' as _i3;
import 'package:movie/presentation/cubit/movie_detail_cubit.dart' as _i4;
import 'package:watchlist/domain/usecases/get_watchlist.dart' as _i5;
import 'package:watchlist/domain/usecases/get_watchlist_status.dart' as _i6;
import 'package:watchlist/domain/usecases/remove_watchlist.dart' as _i8;
import 'package:watchlist/domain/usecases/save_watchlist.dart' as _i7;
import 'package:watchlist/presentation/cubit/watchlist_cubit.dart' as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetMovieDetail_0 extends _i1.SmartFake
    implements _i2.GetMovieDetail {
  _FakeGetMovieDetail_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetMovieRecommendations_1 extends _i1.SmartFake
    implements _i3.GetMovieRecommendations {
  _FakeGetMovieRecommendations_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeMovieDetailState_2 extends _i1.SmartFake
    implements _i4.MovieDetailState {
  _FakeMovieDetailState_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetWatchlist_3 extends _i1.SmartFake implements _i5.GetWatchlist {
  _FakeGetWatchlist_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetWatchListStatus_4 extends _i1.SmartFake
    implements _i6.GetWatchListStatus {
  _FakeGetWatchListStatus_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeSaveWatchlist_5 extends _i1.SmartFake implements _i7.SaveWatchlist {
  _FakeSaveWatchlist_5(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeRemoveWatchlist_6 extends _i1.SmartFake
    implements _i8.RemoveWatchlist {
  _FakeRemoveWatchlist_6(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeWatchlistState_7 extends _i1.SmartFake
    implements _i9.WatchlistState {
  _FakeWatchlistState_7(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [MovieDetailCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieDetailCubit extends _i1.Mock implements _i4.MovieDetailCubit {
  MockMovieDetailCubit() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetMovieDetail get getMovieDetail => (super.noSuchMethod(
          Invocation.getter(#getMovieDetail),
          returnValue:
              _FakeGetMovieDetail_0(this, Invocation.getter(#getMovieDetail)))
      as _i2.GetMovieDetail);
  @override
  _i3.GetMovieRecommendations get getMovieRecommendations =>
      (super.noSuchMethod(Invocation.getter(#getMovieRecommendations),
              returnValue: _FakeGetMovieRecommendations_1(
                  this, Invocation.getter(#getMovieRecommendations)))
          as _i3.GetMovieRecommendations);
  @override
  _i4.MovieDetailState get state => (super.noSuchMethod(
          Invocation.getter(#state),
          returnValue: _FakeMovieDetailState_2(this, Invocation.getter(#state)))
      as _i4.MovieDetailState);
  @override
  _i10.Stream<_i4.MovieDetailState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: _i10.Stream<_i4.MovieDetailState>.empty())
          as _i10.Stream<_i4.MovieDetailState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void fetchMovieDetail(int? id) =>
      super.noSuchMethod(Invocation.method(#fetchMovieDetail, [id]),
          returnValueForMissingStub: null);
  @override
  void emit(_i4.MovieDetailState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void onChange(_i11.Change<_i4.MovieDetailState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  _i10.Future<void> close() =>
      (super.noSuchMethod(Invocation.method(#close, []),
              returnValue: _i10.Future<void>.value(),
              returnValueForMissingStub: _i10.Future<void>.value())
          as _i10.Future<void>);
}

/// A class which mocks [WatchlistCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockWatchlistCubit extends _i1.Mock implements _i9.WatchlistCubit {
  MockWatchlistCubit() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.GetWatchlist get watchlist => (super.noSuchMethod(
          Invocation.getter(#watchlist),
          returnValue: _FakeGetWatchlist_3(this, Invocation.getter(#watchlist)))
      as _i5.GetWatchlist);
  @override
  _i6.GetWatchListStatus get getWatchListStatus =>
      (super.noSuchMethod(Invocation.getter(#getWatchListStatus),
              returnValue: _FakeGetWatchListStatus_4(
                  this, Invocation.getter(#getWatchListStatus)))
          as _i6.GetWatchListStatus);
  @override
  _i7.SaveWatchlist get saveWatchlist =>
      (super.noSuchMethod(Invocation.getter(#saveWatchlist),
              returnValue:
                  _FakeSaveWatchlist_5(this, Invocation.getter(#saveWatchlist)))
          as _i7.SaveWatchlist);
  @override
  _i8.RemoveWatchlist get removeWatchlist => (super.noSuchMethod(
          Invocation.getter(#removeWatchlist),
          returnValue:
              _FakeRemoveWatchlist_6(this, Invocation.getter(#removeWatchlist)))
      as _i8.RemoveWatchlist);
  @override
  _i9.WatchlistState get state => (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeWatchlistState_7(this, Invocation.getter(#state)))
      as _i9.WatchlistState);
  @override
  _i10.Stream<_i9.WatchlistState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: _i10.Stream<_i9.WatchlistState>.empty())
          as _i10.Stream<_i9.WatchlistState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void loadWatchlistStatus(int? id) =>
      super.noSuchMethod(Invocation.method(#loadWatchlistStatus, [id]),
          returnValueForMissingStub: null);
  @override
  void fetchWatchlist() =>
      super.noSuchMethod(Invocation.method(#fetchWatchlist, []),
          returnValueForMissingStub: null);
  @override
  void addWatchlist(_i12.Movie? movie) =>
      super.noSuchMethod(Invocation.method(#addWatchlist, [movie]),
          returnValueForMissingStub: null);
  @override
  void deleteWatchlist(int? id) =>
      super.noSuchMethod(Invocation.method(#deleteWatchlist, [id]),
          returnValueForMissingStub: null);
  @override
  void emit(_i9.WatchlistState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void onChange(_i11.Change<_i9.WatchlistState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  _i10.Future<void> close() =>
      (super.noSuchMethod(Invocation.method(#close, []),
              returnValue: _i10.Future<void>.value(),
              returnValueForMissingStub: _i10.Future<void>.value())
          as _i10.Future<void>);
}
