import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/io_client.dart';
import 'package:tv_series/data/models/epidose_response.dart';
import 'package:tv_series/data/models/episode_model.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/models/tv_series_response.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getNowPlayingTvSeries();
  Future<TvSeriesDetailModel> getDetailTvSeries(int id);
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<List<TvSeriesModel>> getRecommendationTvSeries(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
  Future<List<EpisodeModel>> getTvSeriesEpisode(int id, int season);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  final IOClient client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response = await client
        .get(Uri.parse('$baseUrl/tv/popular?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
      for (var data in result) {
        data.type = 'Tv';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    final response = await client.get(
        Uri.parse('$baseUrl/tv/on_the_air?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
      for (var data in result) {
        data.type = 'Tv';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response = await client.get(
        Uri.parse('$baseUrl/tv/top_rated?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
      for (var data in result) {
        data.type = 'Tv';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetailModel> getDetailTvSeries(int id) async {
    final response = await client
        .get(Uri.parse('$baseUrl/tv/$id?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result = TvSeriesDetailModel.fromJson(json.decode(response.body));
      result.type = 'Tv';
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getRecommendationTvSeries(int id) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/tv/$id/recommendations?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
      for (var data in result) {
        data.type = 'Tv';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/search/tv?api_key=${dotenv.env['api_key']}&query=$query'));
    if (response.statusCode == 200) {
      final result =
          TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
      for (var data in result) {
        data.type = 'Tv';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EpisodeModel>> getTvSeriesEpisode(int id, int season) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/tv/$id/season/$season?api_key=${dotenv.env['api_key']}'));
    if (response.statusCode == 200) {
      return EpisodeResponse.fromJson(json.decode(response.body)).episodeList;
    } else {
      throw ServerException();
    }
  }
}
