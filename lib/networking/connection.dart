import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants.dart';

BaseOptions dioTmdbOptions = BaseOptions(
  baseUrl: 'https://api.themoviedb.org',
  receiveDataWhenStatusError: true,
  connectTimeout: 6 * 1000, // 6 seconds
  receiveTimeout: 6 * 1000, // 6 seconds
);
Dio tmdb = Dio(dioTmdbOptions);

/// Returns movies based on a search [term].
Future getTrending() async {
  Response response;
  try {
    response = await tmdb
        .get('/3/trending/movie/day?api_key=${DotEnv().env['TMDB_KEY']}');
    logger.i('Getting trending movies.');
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
  return response.data;
}

/// Returns movies based on a search [term].
Future searchMovies(String term) async {
  Response response;
  try {
    response = await tmdb.get(
        '/3/search/movie?api_key=${DotEnv().env['TMDB_KEY']}&language=en-US&query=$term&page=1&include_adult=false');
    logger.i('Searching $term in movies.');
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
  return response.data;
}

/// Returns movies based on [id].
Future getMovie(int id) async {
  Response response;
  try {
    response = await tmdb
        .get('/3/movie/$id?api_key=${DotEnv().env['TMDB_KEY']}&language=en-US');
    logger.i('Searching movie with ID : $id.');
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
  return response.data;
}

/// Returns the cast and crew for a movie with [id].
Future getCredits(int id) async {
  Response response;
  try {
    response = await tmdb
        .get('/3/movie/$id/credits?api_key=${DotEnv().env['TMDB_KEY']}');
    logger.i('Getting credings for movie with ID : $id.');
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
  return response.data;
}

/// Returns the upcoming movies.
Future getUpcoming() async {
  Response response;
  try {
    response = await tmdb.get(
        '/3/movie/upcoming?api_key=${DotEnv().env['TMDB_KEY']}&language=en-US&page=1');
    logger.i('Getting upcoming movies');
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
  return response.data;
}

/// Returns the latest movie created in the database.
Future getLatest() async {
  Response response;
  try {
    response = await tmdb.get(
        '/3/movie/latest?api_key=${DotEnv().env['TMDB_KEY']}&language=en-US');
    logger.i('Getting latest movie added');
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
  return response.data;
}
