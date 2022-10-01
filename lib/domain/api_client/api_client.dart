import 'dart:convert';
import 'dart:io';

import 'package:flutter_themoviedb/domain/entity/movie_details.dart';
import 'package:flutter_themoviedb/domain/entity/popular_movie_response.dart';

enum ApiClientExceptionType { network, auth, other, sessionExpired }

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = '39b4e1e858b5616bbce51c9d071ce363';

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final json = await response.jsonDecode();
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<T> _post<T>(
    String path,
    T Function(dynamic json) parser,
    Map<String, dynamic> bodyParameters, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);
      final request = await _client.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      final json = await response.jsonDecode();
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<String> _makeToken() async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result =
        _get('/authentication/token/new', parser, {'api_key': _apiKey});
    return result;
  }

  Future<PopularMovieResponse> popularMovies(int page, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final parameters = {
      'api_key': _apiKey,
      'language': locale,
      'page': page.toString(),
    };
    final result = _get('/movie/popular', parser, parameters);
    return result;
  }

  Future<PopularMovieResponse> searchMovies(
      String? query, int page, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final parameters = {
      'api_key': _apiKey,
      'language': locale,
      'page': page.toString(),
      'query': query,
      'include_adult': true.toString()
    };
    final result = _get('/search/movie', parser, parameters);
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
      'api_key': _apiKey,
      'language': locale,
    };

    final result = _get('/movie/$movieId', parser, parameters);
    return result;
  }

  Future<bool> isMovieFavorite(int movieId, String sessionId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final results = jsonMap['favorite'] as bool;
      return results;
    }

    final parameters = {
      'api_key': _apiKey,
      'session_id': sessionId,
    };

    final result = _get('/movie/$movieId/account_states', parser, parameters);
    return result;
  }

  Future<int> getAccountId(String sessionId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final results = jsonMap['id'] as int;
      return results;
    }

    final parameters = {
      'api_key': _apiKey,
      'session_id': sessionId,
    };

    final result = _get('/account', parser, parameters);
    return result;
  }

  Future<List<dynamic>> getReleasesDates(int movieId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final results = jsonMap['results'] as List<dynamic>;
      return results;
    }

    final parameters = {
      'api_key': _apiKey,
    };

    final result = _get('/movie/$movieId/release_dates', parser, parameters);
    return result;
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String requestToken}) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken
    };
    final result = _post(
      '/authentication/token/validate_with_login',
      parser,
      parameters,
      {'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    }

    final parameters = <String, dynamic>{'request_token': requestToken};
    final result = _post(
      '/authentication/session/new',
      parser,
      parameters,
      {'api_key': _apiKey},
    );
    return result;
  }

  Future<int> makeMovieFavorite({
    required String sessionId,
    required int accountId,
    required int mediaId,
    required bool isFavorite,
    required MediaType mediaType,
  }) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final statusCode = jsonMap['status_code'] as int;
      return statusCode;
    }

    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': isFavorite
    };
    final result = _post(
      '/account/$accountId/favorite',
      parser,
      parameters,
      {'api_key': _apiKey, 'session_id': sessionId},
    );
    return result;
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then((v) => json.decode(v) as Map<String, dynamic>);
  }
}
