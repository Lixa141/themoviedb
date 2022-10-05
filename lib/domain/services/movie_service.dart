import 'package:flutter_themoviedb/configuration/configuration.dart';
import 'package:flutter_themoviedb/domain/clients/account_api_client.dart';
import 'package:flutter_themoviedb/domain/clients/movie_api_client.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:flutter_themoviedb/domain/entity/popular_movie_response.dart';
import 'package:flutter_themoviedb/domain/local_entity/movie_details_local.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> getPopularMovies(
          int nextPage, String locale) async =>
      _movieApiClient.popularMovies(nextPage, locale, Configuration.apiKey);

  Future<PopularMovieResponse> getSearchedMovies(
          int nextPage, String locale, String query) async =>
      _movieApiClient.searchMovies(
          query, nextPage, locale, Configuration.apiKey);

  Future<MovieDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isMovieFavorite(movieId, sessionId);
    }
    return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  Future<String> getCertificate({
    required int movieId,
    required String locale,
  }) async {
    final releaseDates = await _movieApiClient.getReleasesDates(movieId);
    final localeCountry = locale.split('-')[1];
    final releaseDate = releaseDates
        .where((element) => element['iso_3166_1'] == localeCountry)
        .toList();
    if (releaseDate.isNotEmpty) {
      return releaseDate[0]['release_dates'][0]['certification'].toString();
    } else {
      return '';
    }
  }

  Future<void> toggleIsFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    await _accountApiClient.makeMovieFavorite(
      sessionId: sessionId,
      accountId: accountId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }
}
