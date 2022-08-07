part of 'episode_cubit.dart';

@immutable
abstract class EpisodeState extends Equatable {
  const EpisodeState();

  @override
  List<Object?> get props => [];
}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoading extends EpisodeState {}

class EpisodeLoaded extends EpisodeState {
  final List<Episode> episode;

  const EpisodeLoaded(this.episode);

  @override
  List<Object?> get props => [episode];
}

class EpisodeError extends EpisodeState {
  final String message;

  const EpisodeError(this.message);

  @override
  List<Object?> get props => [message];
}
