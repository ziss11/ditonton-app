import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/data/models/episode_model.dart';
import 'package:tv_series/domain/entities/episode.dart';

void main() {
  const tEpisodeModel = EpisodeModel(
    airDate: 'airDate',
    episodeNumber: 0,
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 0,
    stillPath: 'stillPath',
    voteAverage: 0.0,
    voteCount: 0,
  );

  const tEpisode = Episode(
    airDate: 'airDate',
    episodeNumber: 0,
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 0,
    stillPath: 'stillPath',
    voteAverage: 0.0,
    voteCount: 0,
  );

  test('should be a subclass of Episode entity', () async {
    final result = tEpisodeModel.toEntity();
    expect(result, tEpisode);
  });
}
