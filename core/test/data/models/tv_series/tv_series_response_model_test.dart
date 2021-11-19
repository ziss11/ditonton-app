import 'dart:convert';

import 'package:core/data/models/tv_series/tv_series_model.dart';
import 'package:core/data/models/tv_series/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    type: 'Tv',
    backdropPath: '/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg',
    firstAirDate: '2006-09-18',
    id: 1991,
    ids: const [10767],
    title: 'Rachael Ray',
    originCountry: const ["US"],
    originalLanguage: 'en',
    originalName: 'Rachael Ray',
    overview:
        'Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show\'s 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio. In January 2012, CBS Television Distribution announced a two-year renewal for the show, taking it through the 2013–14 season.',
    popularity: 2076.655,
    posterPath: '/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg',
    voteAverage: 5.8,
    voteCount: 29,
  );

  final tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);

  group('from json', () {
    test('should return a valid model from JSON ', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json
          .decode(readJson('dummy_data/tv_series/tv_series_now_playing.json'));
      //act
      final result = TvSeriesResponse.fromJson(jsonMap);
      //assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('to json', () {
    test('should return a JSON map containing proper data', () async {
      //act
      final result = tTvSeriesResponseModel.toJson();
      //assert
      final expectedJson = {
        "results": [
          {
            'type': 'Tv',
            "backdrop_path": "/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg",
            "first_air_date": "2006-09-18",
            "genre_ids": [10767],
            "id": 1991,
            "title": "Rachael Ray",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Rachael Ray",
            "overview":
                "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio. In January 2012, CBS Television Distribution announced a two-year renewal for the show, taking it through the 2013–14 season.",
            "popularity": 2076.655,
            "poster_path": "/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg",
            "vote_average": 5.8,
            "vote_count": 29
          }
        ]
      };
      expect(result, expectedJson);
    });
  });
}
