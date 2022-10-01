import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client.dart';
import 'package:flutter_themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:flutter_themoviedb/domain/entity/movie_details.dart';
import 'package:flutter_themoviedb/domain/entity/movie_details_credits.dart';
import 'package:intl/intl.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String? _genres;
  String _locale = '';
  late DateFormat _dateFormat;
  String? _certificate;
  String? _runTime;
  final List<Crew> _filteredCrew = <Crew>[];
  bool _isFavorite = false;
  Future<void>? Function()? onSessionExpired;

  MovieDetails? get movieDetails => _movieDetails;

  String? get certificate => _certificate;

  String? get runTime => _runTime;

  String? get genres => _genres;

  List<Crew>? get filteredCrew => _filteredCrew;

  bool? get isFavorite => _isFavorite;

  MovieDetailsModel(this.movieId);

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await getCertificate();
    await loadDetails();
    formatRunTime();
    formatGenres();
    filterCrew();
  }

  Future<void> loadDetails() async {
    try {
      _movieDetails = await _apiClient.movieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _apiClient.isMovieFavorite(movieId, sessionId);
      }
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> getCertificate() async {
    var certificate = '';
    final releaseDates = await _apiClient.getReleasesDates(movieId);
    final localeCountry = _locale.split('-')[1];
    final releaseDate = releaseDates
        .where((element) => element['iso_3166_1'] == localeCountry)
        .toList();
    if (releaseDate.isNotEmpty) {
      certificate =
          releaseDate[0]['release_dates'][0]['certification'].toString();
      _certificate = certificate;
    }
  }

  Future<void> toggleIsFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    _isFavorite = !_isFavorite;

    try {
      await _apiClient.makeMovieFavorite(
        sessionId: sessionId,
        accountId: accountId,
        mediaType: MediaType.movie,
        mediaId: movieId,
        isFavorite: _isFavorite,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  void formatRunTime() {
    final runTime = _movieDetails?.runtime ?? 0;
    final hour = runTime ~/ 60;
    final minutes = runTime - hour * 60;
    var result = hour > 0 ? '${hour}h ' : '';
    minutes > 0 ? result += '${minutes}m' : '';
    _runTime = result;
  }

  void formatGenres() {
    final genres = _movieDetails?.genres.toList();
    var result = '';
    if (genres != null) {
      result += genres.map((e) => e.name).toString();
      _genres = result.replaceAll(RegExp('[()]'), '');
    }
  }

  void filterCrew() {
    final crew = movieDetails?.credits.crew;
    if (crew != null) {
      final sortedByPopularityCrew = crew
        ..sort((b, a) => a.popularity.compareTo(b.popularity));
      var job = sortedByPopularityCrew[0].job;
      for (var i = 1; i < sortedByPopularityCrew.length; i++) {
        final current = sortedByPopularityCrew[i];
        final previous = sortedByPopularityCrew[i - 1];
        if (current.id == previous.id) {
          job += ', ' + sortedByPopularityCrew[i].job;
        } else {
          _filteredCrew.add(Crew(
            adult: previous.adult,
            gender: previous.gender,
            id: previous.id,
            knownForDepartment: previous.knownForDepartment,
            name: previous.name,
            originalName: previous.originalName,
            popularity: previous.popularity,
            profilePath: previous.profilePath,
            creditId: previous.creditId,
            department: previous.department,
            job: job,
          ));
          if (_filteredCrew.length >= 4) return;
          job = current.job;
        }
      }
      return;
    }
  }

  void _handleApiClientException(ApiClientException exception) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        onSessionExpired?.call();
        break;
      default:
        print(exception);
    }
  }
}
