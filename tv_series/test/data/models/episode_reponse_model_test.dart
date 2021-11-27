import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/data/models/epidose_response.dart';
import 'package:tv_series/data/models/episode_model.dart';

import '../../json_reader.dart';

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

  const tEpisodeResponseModel = EpisodeResponse(
    episodeList: [tEpisodeModel],
  );
  group('from json', () {
    test('should return a valid model from JSON ', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_series_episode.json'));
      //act
      final result = EpisodeResponse.fromJson(jsonMap);
      //assert
      expect(result, tEpisodeResponseModel);
    });
  });
  group('to json', () {
    test('should return a JSON map containing proper data', () async {
      //act
      final result = tEpisodeResponseModel.toJson();
      //assert
      final expectedJson =
          json.decode(readJson('dummy_data/tv_series_episode.json'));
      expect(result, expectedJson);
    });
  });
}
