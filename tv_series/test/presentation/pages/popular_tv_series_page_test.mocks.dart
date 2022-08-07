// Mocks generated by Mockito 5.0.16 from annotations
// in tv_series/test/presentation/pages/popular_tv_series_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:bloc/bloc.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:tv_series/domain/usecase/get_popular_tv_series.dart' as _i2;
import 'package:tv_series/presentation/cubit/tv_series_popular_cubit.dart'
    as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeGetPopularTvSeries_0 extends _i1.Fake
    implements _i2.GetPopularTvSeries {}

class _FakeTvSeriesPopularState_1 extends _i1.Fake
    implements _i3.TvSeriesPopularState {}

class _FakeStreamSubscription_2<T> extends _i1.Fake
    implements _i4.StreamSubscription<T> {}

/// A class which mocks [TvSeriesPopularCubit].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvSeriesPopularCubit extends _i1.Mock
    implements _i3.TvSeriesPopularCubit {
  MockTvSeriesPopularCubit() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetPopularTvSeries get popularTvSeries =>
      (super.noSuchMethod(Invocation.getter(#popularTvSeries),
          returnValue: _FakeGetPopularTvSeries_0()) as _i2.GetPopularTvSeries);
  @override
  _i3.TvSeriesPopularState get state => (super.noSuchMethod(
      Invocation.getter(#state),
      returnValue: _FakeTvSeriesPopularState_1()) as _i3.TvSeriesPopularState);
  @override
  _i4.Stream<_i3.TvSeriesPopularState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i3.TvSeriesPopularState>.empty())
          as _i4.Stream<_i3.TvSeriesPopularState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void fetchPopularTv() =>
      super.noSuchMethod(Invocation.method(#fetchPopularTv, []),
          returnValueForMissingStub: null);
  @override
  _i4.StreamSubscription<_i3.TvSeriesPopularState> listen(
          void Function(_i3.TvSeriesPopularState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue:
                  _FakeStreamSubscription_2<_i3.TvSeriesPopularState>())
          as _i4.StreamSubscription<_i3.TvSeriesPopularState>);
  @override
  void emit(_i3.TvSeriesPopularState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void onChange(_i5.Change<_i3.TvSeriesPopularState>? change) =>
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
  _i4.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  String toString() => super.toString();
}