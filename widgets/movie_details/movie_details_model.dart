import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/clients/api_client_exception.dart';
import 'package:flutter_themoviedb/domain/entity/movie_details.dart';
import 'package:flutter_themoviedb/domain/entity/movie_details_credits.dart';
import 'package:flutter_themoviedb/domain/services/auth_service.dart';
import 'package:flutter_themoviedb/domain/services/movie_service.dart';
import 'package:flutter_themoviedb/library/widgets/localized_model.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';
import 'package:intl/intl.dart';

class MovieDetailsDataTopPoster {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;

  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_outline;

  MovieDetailsDataTopPoster({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailsDataTopPoster copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailsDataTopPoster(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsMovieNameData {
  final String title;
  final String year;

  MovieDetailsMovieNameData({required this.title, required this.year});
}

class MovieDetailsScoreData {
  final String? videoKey;
  final double voteAverage;

  MovieDetailsScoreData({this.videoKey, required this.voteAverage});
}

class MovieDetailsSummaryData {
  final String certification;
  final String summary;
  final String? genres;

  MovieDetailsSummaryData({
    required this.certification,
    this.summary = '',
    this.genres,
  });
}

class MovieDetailsCrewData {
  final String name;
  final String job;

  MovieDetailsCrewData({required this.name, required this.job});
}

class MovieDetailsCastData {
  final String? profilePath;
  final String name;
  final String character;

  MovieDetailsCastData({
    this.profilePath,
    required this.name,
    required this.character,
  });
}

class MovieDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsDataTopPoster topPosterData = MovieDetailsDataTopPoster();
  MovieDetailsMovieNameData movieNameData =
      MovieDetailsMovieNameData(title: '', year: '');
  MovieDetailsScoreData scoreData = MovieDetailsScoreData(voteAverage: 0);
  MovieDetailsSummaryData summaryData =
      MovieDetailsSummaryData(certification: '');
  String tagline = '';
  List<MovieDetailsCrewData> crewData = const <MovieDetailsCrewData>[];
  List<MovieDetailsCastData> castData = const <MovieDetailsCastData>[];
}

class MovieDetailsModel extends ChangeNotifier {
  final _authService = AuthService();
  final _movieService = MovieService();

  final int movieId;
  final  _localeStorage = LocalizedModelStorage();
  final data = MovieDetailsData();
  String? _genres;
  late DateFormat _dateFormat;
  String? _certificate;
  String? _runTime;
  final List<Crew> _filteredCrew = <Crew>[];

  String? get certificate => _certificate;

  String? get runTime => _runTime;

  String? get genres => _genres;

  List<Crew>? get filteredCrew => _filteredCrew;

  MovieDetailsModel(this.movieId);

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localTag);
    await getCertificate();
    updateData(null, false);
    await loadDetails(context);
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    formatRunTime(details);
    formatGenres(details);
    filterCrew(details);

    data.title = details?.title ?? 'Loading';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    data.topPosterData = MovieDetailsDataTopPoster(
        backdropPath: details.backdropPath,
        posterPath: details.posterPath,
        isFavorite: isFavorite);
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.movieNameData = MovieDetailsMovieNameData(
      title: details.title,
      year: year,
    );

    final videos =
        details.videos.results.where((video) => video.site == 'YouTube');
    final videoKey = videos.isNotEmpty ? videos.first.key : null;

    var voteAverage = details.voteAverage * 10;

    data.scoreData = MovieDetailsScoreData(
      videoKey: videoKey,
      voteAverage: voteAverage,
    );

    data.summaryData = MovieDetailsSummaryData(
      certification: _certificate ?? '',
      summary: makeSummary(details),
      genres: _genres,
    );

    data.tagline = details.tagline ?? '';
    data.crewData = _filteredCrew
        .map((person) =>
            MovieDetailsCrewData(name: person.name, job: person.job))
        .toList();
    data.castData = details.credits.cast
        .map((person) => MovieDetailsCastData(
              profilePath: person.profilePath,
              name: person.name,
              character: person.character,
            ))
        .toList();
    notifyListeners();
  }

  String makeSummary(MovieDetails details) {
    var text = '';

    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      text += '${stringFromDate(releaseDate)} ';
    }
    final productionCountries = details.productionCountries;
    if (productionCountries.isNotEmpty) {
      text += '(${productionCountries.first.iso}) ';
    }
    final runTime = _runTime;
    runTime != null ? text += '• $runTime ' : null;

    return text;
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> getCertificate() async {
    final certificate =
        await _movieService.getCertificate(movieId: movieId, locale: _localeStorage.localTag);
    _certificate = certificate;
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final details =
          await _movieService.loadDetails(movieId: movieId, locale: _localeStorage.localTag);

      updateData(details.details, details.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  Future<void> toggleIsFavorite(BuildContext context) async {
    data.topPosterData =
        data.topPosterData.copyWith(isFavorite: !data.topPosterData.isFavorite);
    notifyListeners();

    try {
      await _movieService.toggleIsFavorite(
          movieId: movieId, isFavorite: data.topPosterData.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void formatRunTime(MovieDetails? details) {
    final runTime = details?.runtime ?? 0;
    final hour = runTime ~/ 60;
    final minutes = runTime - hour * 60;
    var result = hour > 0 ? '${hour}h ' : '';
    minutes > 0 ? result += '${minutes}m' : '';
    _runTime = result;
  }

  void formatGenres(MovieDetails? details) {
    final genres = details?.genres.toList();
    var result = '';
    if (genres != null) {
      result += genres.map((e) => e.name).toString();
      _genres = result.replaceAll(RegExp('[()]'), '');
    }
  }

  void filterCrew(MovieDetails? details) {
    final crew = details?.credits.crew;
    if (crew != null) {
      final sortedByPopularityCrew = crew
        ..sort((b, a) => a.popularity.compareTo(b.popularity));
      var job = sortedByPopularityCrew[0].job;
      for (var i = 1; i < sortedByPopularityCrew.length; i++) {
        final current = sortedByPopularityCrew[i];
        final previous = sortedByPopularityCrew[i - 1];
        if (current.id == previous.id) {
          job += ', ${sortedByPopularityCrew[i].job}';
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

  void _handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exception.type);
    }
  }
}
