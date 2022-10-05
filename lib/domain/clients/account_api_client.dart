import 'package:flutter_themoviedb/configuration/configuration.dart';
import 'package:flutter_themoviedb/domain/clients/network_client.dart';


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

class AccountApiClient {

  final _networkClient = NetworkClient();

  Future<int> getAccountId(String sessionId) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final results = jsonMap['id'] as int;
      return results;
    }

    final parameters = {
      'api_key': Configuration.apiKey,
      'session_id': sessionId,
    };

    final result = _networkClient.get('/account', parser, parameters);
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
    final result = _networkClient.post(
      '/account/$accountId/favorite',
      parser,
      parameters,
      {'api_key': Configuration.apiKey, 'session_id': sessionId},
    );
    return result;
  }
}