import 'package:flutter_themoviedb/configuration/configuration.dart';
import 'package:flutter_themoviedb/domain/clients/network_client.dart';
import 'package:flutter_themoviedb/domain/entity/movie_details.dart';
import 'package:flutter_themoviedb/domain/entity/popular_movie_response.dart';

class MovieApiClient {
  final _networkClient = NetworkClient();

  Future<PopularMovieResponse> popularMovies(int page, String locale, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final parameters = {
      'api_key': apiKey,
      'language': locale,
      'page': page.toString(),
    };
    final result =
        _networkClient.get('/movie/popular', parser, parameters);
    return result;
  }

  Future<PopularMovieResponse> searchMovies(
      String? query, int page, String locale, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final parameters = {
      'api_key': apiKey,
      'language': locale,
      'page': page.toString(),
      'query': query,
      'include_adult': true.toString()
    };
    final result =
        _networkClient.get('/search/movie', parser, parameters);
    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final parameters = {
      'append_to_response': 'credits,videos',
      'api_key': Configuration.apiKey,
      'language': locale,
    };

    final result =
        _networkClient.get('/movie/$movieId', parser, parameters);
    return result;
  }

  Future<bool> isMovieFavorite(int movieId, String sessionId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final results = jsonMap['favorite'] as bool;
      return results;
    }

    final parameters = {
      'api_key': Configuration.apiKey,
      'session_id': sessionId,
    };

    final result = _networkClient.get(
        '/movie/$movieId/account_states', parser, parameters);
    return result;
  }


  Future<List<dynamic>> getReleasesDates(int movieId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final results = jsonMap['results'] as List<dynamic>;
      return results;
    }

    final parameters = {
      'api_key': Configuration.apiKey,
    };

    final result = _networkClient.get(
        '/movie/$movieId/release_dates', parser, parameters);
    return result;
  }


}
