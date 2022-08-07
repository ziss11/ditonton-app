import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/io_client.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/data/models/movie_model.dart';
import 'package:movie/data/models/movie_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final IOClient client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get(Uri.parse(
        '$baseUrl/movie/now_playing?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          MovieResponse.fromJson(json.decode(response.body)).movieList;
      for (var data in result) {
        data.type = 'Movie';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client
        .get(Uri.parse('$baseUrl/movie/$id?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result = MovieDetailResponse.fromJson(json.decode(response.body));
      result.type = 'Movie';

      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/movie/$id/recommendations?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          MovieResponse.fromJson(json.decode(response.body)).movieList;
      for (var data in result) {
        data.type = 'Movie';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await client.get(
        Uri.parse('$baseUrl/movie/popular?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          MovieResponse.fromJson(json.decode(response.body)).movieList;
      for (var data in result) {
        data.type = 'Movie';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await client.get(
        Uri.parse('$baseUrl/movie/top_rated?api_key=${dotenv.env['api_key']}'));

    if (response.statusCode == 200) {
      final result =
          MovieResponse.fromJson(json.decode(response.body)).movieList;
      for (var data in result) {
        data.type = 'Movie';
      }
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/search/movie?api_key=${dotenv.env['api_key']}&query=$query'));

    if (response.statusCode == 200) {
      final result =
          MovieResponse.fromJson(json.decode(response.body)).movieList;
      for (var data in result) {
        data.type = 'Movie';
      }
      return result;
    } else {
      throw ServerException();
    }
  }
}
